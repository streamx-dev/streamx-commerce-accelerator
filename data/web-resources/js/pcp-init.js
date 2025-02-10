!function() {
    const FILTER_CONTAINER_ID = 'category-list';
    const PCP_CONTAINER_ID = 'product-category-component';
    const RESULTS_CONTAINER_ID = 'product-list';
    const LOAD_MORE_BUTTON_ID = 'load-more-button';
    const PER_PAGE = 6;
    const SEARCH_URL = '/search/query';
    const DEFAULT_IMG = '../data/assets/342x457.webp';

    let currentPage = 0;
    let activeFilters = [];
    let initFilters = true;
      
    const mapToPagesResponse = (response) => {;
      const items = [];
      const respItems = response.hits;
      for (var i = 0; i < respItems.length; i++) {
          const tmpItem = respItems[i]._source?.payload;
          const item = {
            imgSrc: tmpItem?.primaryImage?.url || DEFAULT_IMG,
            imgAlt: tmpItem?.primaryImage?.alt || '',
            name: tmpItem?.name || '',
            description: tmpItem?.description || '',
            price: tmpItem?.price?.value || '', // not sure if value or discountedValue
            keywords: tmpItem?.ft_keyword || []
          }

          items.push(item);
        }
      return items;
    };

    const mapFacets = (response) => {
      const categories = Object.keys(response);
      const mappedFacets = {};

      for (var i = 0; i < categories.length; i++) {
        if (response[categories[i]].buckets.length > 0) {
          mappedFacets[categories[i]] = response[categories[i]].buckets;
        }
      }

      return mappedFacets;
    };

    const buildQuery = (category, facets) => {

      const query  = {
        'id': 'products',
        'params': {
          'from': PER_PAGE*currentPage,
          'size': PER_PAGE,
          'filter_category': {
            'fields': [category]
          },
          'facets': {
            'fields': facets.map((f, index) => {
              return {
                'name': Object.keys(f)[0],
                'size': 20,
                'last': index === facets.length - 1
              }
            })
          }
        }
      };
  
      if (activeFilters && activeFilters.length > 0) {
        query.params["filter_query"] = {
          "fields": activeFilters.map(f => {
            return {
              "name": f.name,
              "values": f.values,
            }
          })
        };
      }
      return JSON.stringify(query);
    };

    const getItemTemplate = (item) => {
        // picture tag will require all below once we have all of the renditions
        // <source media="(max-width: 639px)" srcset="../assets/573x765.webp">
        // <source media="(min-width: 640px) and (max-width: 767px)" srcset="../assets/124x166.webp">
        // <source media="(min-width: 768px) and (max-width: 1023px)" srcset="../assets/156x209.webp">
        // <source media="(min-width: 1024px) and (max-width: 1279px)" srcset="../assets/220x294.webp">
        // <source media="(min-width: 1280px) and (max-width: 1535px)" srcset="../assets/278x372.webp">
        // <source media="(min-width: 1536px)" srcset="../assets/342x457.webp">
        return `
              <div class="flex flex-col h-full">
                <figure class="w-full aspect-[3/4] flex">
                  <picture class="w-full object-cover content-center">
                    <img class="w-full" src="${item.imgSrc}" loading="lazy" alt=""/>
                  </picture>
                </figure>
                <div class="mt-4 flex gap-y-2 flex-wrap flex-1">
                  <div class="flex flex-col flex-grow w-full p-4">
                    <p class="text-base font-bold text-gray-700 truncate mb-4">
                      ${ item.name }
                    </p>
                    <p class="text-sm text-gray-500 text-wrap mb-4">
                      ${ item.description }
                    </p>
                    <p class="text-sm text-gray-500 text-wrap italic">
                      ${ item.keywords.join(', ') }
                    </p>
                    <p class="text-base font-bold text-gray-700 flex-grow content-end mt-2">
                      ${ item.price } &euro;
                    </p>
                  </div>
                </div>
              </div>`;
    };

    const getFilterTemplate = (name, filters, label) => {
      const tmp =  `<fieldset>
        <legend class="font-medium text-gray-700 mb-4">${label}</legend>
          <div class="pt-2">
            ${ filters.map((f,i) => { return `<div class="flex gap-2">
                <div class="flex items-center mb-4">
                  <input id="${name}-${i}" name="${name}[]" type="checkbox" class="checkbox-filter w-4 h-4 text-gray-400 bg-gray-100 border-gray-300 rounded-sm focus:ring-2" value="${f.key}">
                  <label for="${name}-${i}" class="ms-2 text-sm font-medium text-gray-400 font-thin">${f.key}</label>
                </div>
              </div>`
            }).join('')}
        </div>
        <hr class="my-4 md:my-6 border-gray-200"/>
      </fieldset>`
      
      return tmp;
    };

    const handleFilterChange = (event) => {
      if (event.target.value) {
        currentPage = 0;
        const checkbox = event.target;
        const checkboxGroupName = checkbox.name.replace(/\[\]$/, '');
        const facetVal = event.target.value;
        const filter = activeFilters.find(f => f.name === checkboxGroupName);

        if (event.target.checked) {
          if (filter) {
            filter.values.push(facetVal);
          } else {
            activeFilters.push({name: checkboxGroupName, values: [facetVal]})
          }
        } else {
          if (filter) {
            filter.values = filter.values.filter(val => val !== facetVal);
          }
        }
        fetchProductData();
      }
    }

    const handleResponse = (response, availableFacets) => {
      const ul = document.getElementById(RESULTS_CONTAINER_ID);
      const products =  mapToPagesResponse(response.hits);

      products.forEach((product) => {
        const li = document.createElement('li');
        li.classList.add('border-neutral-200', 'border', 'items-center', 'rounded-md', 'truncate');
        li.innerHTML = getItemTemplate(product).trim();
        ul.appendChild(li);
      });
      
      if (initFilters) {
        const facetsUl = document.getElementById(FILTER_CONTAINER_ID);
        const facets = mapFacets(response.aggregations);

        Object.keys(facets).forEach((facetKey) => {
          const facetObject = availableFacets.find(item => facetKey in item);
          if(facetObject) {
            const facetLabel = facetObject ? facetObject[facetKey] : '';
            const li = document.createElement('li');
            li.innerHTML = getFilterTemplate(facetKey, facets[facetKey], facetLabel).trim();
            facetsUl.appendChild(li);
          }
        });
  
        document.getElementById(PCP_CONTAINER_ID).onclick = (event) => handleFilterChange(event);
        initFilters = false;
      }
      currentPage++;
      const loadMoreButton = document.getElementById(LOAD_MORE_BUTTON_ID);
      response.hits.total.value > PER_PAGE*currentPage ? loadMoreButton.classList.remove('hidden'):loadMoreButtonel.classList.add('hidden');
    }

    const fetchProductData = () => {
      const category = document.getElementById(PCP_CONTAINER_ID).getAttribute('data-category');
      const availableFacets = JSON.parse(document.getElementById(PCP_CONTAINER_ID).getAttribute('data-filters'));

      fetch(SEARCH_URL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: buildQuery(category, availableFacets)
      })
      .then((response) => {
        const json = response.json();
        handleResponse(json, availableFacets);
      })
      .catch((response) => {
        console.log(response.status, response.statusText);
        handleResponse(mocks, availableFacets); // here we mock for now from pcp-mocks
      });
    }

    const init = () => {
      const pageIsPCP = document.getElementById(PCP_CONTAINER_ID);
      if(!pageIsPCP) {
        return;
      }
      const loadMoreButton = document.getElementById(LOAD_MORE_BUTTON_ID);
      loadMoreButton.addEventListener('click', function () {
        fetchProductData();
      });

      fetchProductData();
    }

    init();
}();
