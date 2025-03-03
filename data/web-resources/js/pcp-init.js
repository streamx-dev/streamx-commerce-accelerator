!function () {
  const FILTER_CONTAINER_ID = 'category-list';
  const PCP_CONTAINER_ID = 'product-category-component';
  const RESULTS_CONTAINER_ID = 'product-list';
  const LOAD_MORE_BUTTON_ID = 'load-more-button';
  const PER_PAGE = 6;
  const SEARCH_URL = '/search/query/body';
  const DEFAULT_IMG = '../data/assets/342x457.webp';

  let currentPage = 0;
  let activeFilters = [];
  let initFilters = true;

  const mapToPagesResponse = (response) => {
    ;
    const items = [];
    const respItems = response?.hits || [];

    for (let i = 0; i < respItems.length; i++) {
      const tmpItem = respItems[i]._source?.payload;
      const item = {
        imgSrc: tmpItem?.primaryImage?.url || DEFAULT_IMG,
        imgAlt: tmpItem?.primaryImage?.alt || '',
        name: tmpItem?.name || '',
        slug: tmpItem?.slug || '',
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

    const query = {
      'id': 'products',
      'params': {
        'from': PER_PAGE * currentPage,
        'size': PER_PAGE,
        'filter_category': {
          'fields': [category]
        },
      }
    };

    if (facets && facets.length > 0) {
      query['params']['facets'] = {
        'fields': facets.map((f, index) => {
          return {
            'name': Object.keys(f)[0],
            'size': 20,
            'last': index === facets.length - 1 ? true : false
          }
        })
      }
    }
    if (activeFilters && activeFilters.length > 0) {
      query.params["filter_query"] = {
        "fields": activeFilters.map((f, index) => {
          return {
            "name": f.name,
            "values": f.values,
            'last': index === activeFilters.length - 1 ? true : false
          }
        })
      };
    }

    return JSON.stringify(query);
  };

  const getItemTemplate = (item) => {
    console.log(item);
    // picture tag will require all below once we have all of the renditions
    // <source media="(max-width: 639px)" srcset="../assets/573x765.webp">
    // <source media="(min-width: 640px) and (max-width: 767px)" srcset="../assets/124x166.webp">
    // <source media="(min-width: 768px) and (max-width: 1023px)" srcset="../assets/156x209.webp">
    // <source media="(min-width: 1024px) and (max-width: 1279px)" srcset="../assets/220x294.webp">
    // <source media="(min-width: 1280px) and (max-width: 1535px)" srcset="../assets/278x372.webp">
    // <source media="(min-width: 1536px)" srcset="../assets/342x457.webp">

    const itemName = (item.name).replace(/&quot;/g, "'");
    const result = itemName.length > 30 ? itemName.slice(0, 30) + '...' : itemName;
    const itemReview = item.review ? item.review : null;
    let reviewsMarkup = '';
    if (itemReview != null) {
      let svgClass = 'lucide lucide-star w-4 h-4 fill-yellow-400 text-yellow-400';
      for (let i = 1; i <= 5; i++) {
        if (i > itemReview) {
          svgClass = 'lucide lucide-star w-4 h-4 text-gray-300'
        }
        reviewsMarkup += `
      <svg class="${svgClass}" fill="none" height="24" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
      viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
        <path
          d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"
        ></path>
      </svg>`
      }
    }
    return `
              <a href="/products/${item.slug}.html" data-discover="true">
                <div class="aspect-square relative">
                  <img class="w-full h-full object-cover" src="${item.imgSrc}" loading="lazy" alt="${item.imgAlt}"/>
                </div>
              </a>
              <div class="p-4">
                <a href="/products/${item.slug}.html" data-discover="true">
                  <h3 class="font-semibold text-lg mb-2">${result}</h3>
                </a>
                <div class="flex items-center mb-2">
                  ${reviewsMarkup}
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-lg font-bold">$${item.price}</span>
                  <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 h-10 px-4 py-2 bg-dsg-red hover:bg-dsg-red/90 text-white">
                    Add to Cart
                  </button>
                </div>
              </div>`;
  };

  const getFilterTemplate = (name, filters, label) => {
    const tmp = `<fieldset>
        <legend class="font-semibold mb-4">${label}</legend>
          <div class="space-y-2">
            ${filters.map((f, i) => {
      return `<div class="flex gap-2">
                <div class="flex items-center space-x-2">
                  <input id="${name}-${i}" name="${name}[]" type="checkbox" class="peer h-4 w-4 shrink-0 rounded-xs border border-primary ring-offset-background focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground" value="${f.key}">
                  <label for="${name}-${i}">${f.key}</label>
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
          activeFilters.push({ name: checkboxGroupName, values: [facetVal] })
        }
      } else {
        if (filter) {
          filter.values = filter.values.filter(val => val !== facetVal);
        }
        if (filter.values.length === 0) {
          activeFilters = activeFilters.filter(f => f.name !== checkboxGroupName);
        }
      }
      fetchProductData();
    }
  }

  const handleResponse = (response, availableFacets) => {
    const ul = document.getElementById(RESULTS_CONTAINER_ID);
    const products = mapToPagesResponse(response.hits);

    if (currentPage === 0) {
      ul.innerHTML = '';
    }

    products.forEach((product) => {
      const li = document.createElement('li');
      li.classList.add('bg-white', 'rounded-lg', 'shadow-md', 'overflow-hidden', 'transition-transform', 'hover:scale-[1.02]');
      li.innerHTML = getItemTemplate(product).trim();
      ul.appendChild(li);
    });

    if (initFilters) {
      const facetsUl = document.getElementById(FILTER_CONTAINER_ID);
      const facets = mapFacets(response.aggregations);

      Object.keys(facets).forEach((facetKey) => {
        const facetObject = availableFacets.find(item => facetKey in item);
        if (facetObject) {
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
    response.hits.total.value > PER_PAGE * currentPage ? loadMoreButton.classList.remove('hidden') : loadMoreButton.classList.add('hidden');
  }

  const fetchProductData = () => {
    const category = document.getElementById(PCP_CONTAINER_ID).getAttribute('data-category');
    const filterJSON = document.getElementById(PCP_CONTAINER_ID).getAttribute('data-filters');
    let availableFacets = []
    if (filterJSON) {
      availableFacets = JSON.parse(filterJSON);
    }

    fetch(SEARCH_URL, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: buildQuery(category, availableFacets)
    })
      .then((response) => response.json())
      .then((response) => {
        handleResponse(response, availableFacets);
      });
  }

  const init = () => {
    const pageIsPCP = document.getElementById(PCP_CONTAINER_ID);
    if (!pageIsPCP) {
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
