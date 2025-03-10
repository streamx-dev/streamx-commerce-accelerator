// eslint-disable-next-line func-names,no-unused-expressions
!(function () {
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

  const decode = (input) => {
    const parser = new DOMParser();
    const doc = parser.parseFromString(input, 'text/html');
    return doc.documentElement.textContent;
  };

  const truncateString = (str, maxLength) =>
    str.length > maxLength ? `${str.slice(0, maxLength - 3)}...` : str;

  const mapToPagesResponse = (response) => {
    const items = [];
    const respItems = response?.hits || [];

    for (let i = 0; i < respItems.length; i++) {
      // eslint-disable-next-line no-underscore-dangle
      const tmpItem = respItems[i]._source?.payload;
      const item = {
        description: tmpItem?.description || '',
        imgAlt: tmpItem?.primaryImage?.alt || '',
        imgSrc: tmpItem?.primaryImage?.url || DEFAULT_IMG,
        keywords: tmpItem?.ft_keyword || [],
        name: tmpItem?.name || '',
        price: tmpItem?.price?.value || '', // not sure if value or discountedValue
        slug: tmpItem?.slug || '',
        sku: tmpItem?.sku || '',
        brand: "LumaX",
        salesOrg: "Perficient"        
      };

      items.push(item);
    }
    return items;
  };

  const mapFacets = (response) => {
    const categories = Object.keys(response);
    const mappedFacets = {};

    for (let i = 0; i < categories.length; i++) {
      if (response[categories[i]].buckets.length > 0) {
        mappedFacets[categories[i]] = response[categories[i]].buckets;
      }
    }

    return mappedFacets;
  };

  const buildQuery = (category, facets) => {
    const query = {
      id: 'products',
      params: {
        filter_category: {
          fields: [category],
        },
        from: PER_PAGE * currentPage,
        size: PER_PAGE,
      },
    };

    if (facets && facets.length > 0) {
      query.params.facets = {
        fields: facets.map((f, index) => ({
          last: index === facets.length - 1,
          name: Object.keys(f)[0],
          size: 20,
        })),
      };
    }
    if (activeFilters && activeFilters.length > 0) {
      query.params.filter_query = {
        fields: activeFilters.map((f, index) => ({
          last: index === activeFilters.length - 1,
          name: f.name,
          values: f.values,
        })),
      };
    }

    return JSON.stringify(query);
  };

  const getRandomNumber = (min, max) => {
    // eslint-disable-next-line no-param-reassign
    min = Math.ceil(min);
    // eslint-disable-next-line no-param-reassign
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  const renderRatings = () => {
    const rating = getRandomNumber(1, 3) + 2;
    const svgClassRoot = ['h-4', 'lucide', 'lucide-star', 'w-4'];
    let svgClass = [];
    const ratingContainer = document.createElement('div');
    [...Array(5)].forEach((_, index) => {
      if (index + 1 > rating) {
        svgClass = [...svgClassRoot, ...['text-gray-300']];
      } else {
        svgClass = [...svgClassRoot, ...['fill-yellow-400', 'text-yellow-400']];
      }
      const ratingIcon = document.createElementNS(
        'http://www.w3.org/2000/svg',
        'svg',
      );
      ratingIcon.setAttribute('width', '24');
      ratingIcon.setAttribute('height', '24');
      ratingIcon.setAttribute('viewBox', '0 0 24 24');
      ratingIcon.setAttribute('fill', 'none');
      ratingIcon.setAttribute('stroke', 'currentColor');
      ratingIcon.setAttribute('stroke-width', '2');
      ratingIcon.setAttribute('stroke-linecap', 'round');
      ratingIcon.setAttribute('stroke-linejoin', 'round');
      ratingIcon.classList.add(...svgClass);

      const path = document.createElementNS(
        'http://www.w3.org/2000/svg',
        'path',
      );
      path.setAttribute(
        'd',
        'M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z',
      );

      ratingIcon.append(path);
      ratingContainer.appendChild(ratingIcon);
    });

    return ratingContainer.innerHTML;
  };

  const getItemTemplate = (item) =>
    // picture tag will require all below once we have all of the renditions
    // <source media="(max-width: 639px)" srcset="../assets/573x765.webp">
    // <source media="(min-width: 640px) and (max-width: 767px)" srcset="../assets/124x166.webp">
    // <source media="(min-width: 768px) and (max-width: 1023px)" srcset="../assets/156x209.webp">
    // <source media="(min-width: 1024px) and (max-width: 1279px)" srcset="../assets/220x294.webp">
    // <source media="(min-width: 1280px) and (max-width: 1535px)" srcset="../assets/278x372.webp">
    // <source media="(min-width: 1536px)" srcset="../assets/342x457.webp">
    `<a href="/products/${item.slug}.html">
        <div class="aspect-square relative">
          <img
            src="${item.imgSrc}"
            alt="${item.name}"
            class="w-full h-full object-contain"
          />
        </div>
        <div class="p-4">
          <a href="/products/${item.slug}.html" data-discover="true"
            ><h3 class="font-semibold text-lg mb-2">${truncateString(decode(item.name), 35)}</h3></a
          >
          
          <div class="flex items-center mb-2">
            ${renderRatings()}
          </div>
          <div class="flex items-center justify-between">
            <span class="text-lg font-bold">$${item.price}</span
            ><button
              class="addToCart inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 h-10 px-4 py-2 bg-dsg-red hover:bg-dsg-red/90 text-white"
            >
              Add to Cart
            </button>
          </div>
        </div>
      </a>
`;

  const getFilterTemplate = (name, filters, label) => {
    const tmp = `<fieldset>
        <legend class="font-semibold mb-4">${label}</legend>
          <div class="space-y-2">
            ${filters
              .map(
                (f, i) => `<div class="flex gap-2">
                <div class="flex items-center space-x-2">
                  <input id="${name}-${i}" name="${name}[]" type="checkbox" class="peer h-4 w-4 shrink-0 rounded-xs border border-primary ring-offset-background focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground" value="${f.key}">
                  <label for="${name}-${i}">${f.key}</label>
                </div>
              </div>`,
              )
              .join('')}
        </div>
        <hr class="my-4 md:my-6 border-gray-200"/>
      </fieldset>`;

    return tmp;
  };

  const handleFilterChange = (event) => {
    if (event.target.value) {
      currentPage = 0;
      const checkbox = event.target;
      const checkboxGroupName = checkbox.name.replace(/\[\]$/, '');
      const facetVal = event.target.value;
      const filter = activeFilters.find((f) => f.name === checkboxGroupName);

      if (event.target.checked) {
        if (filter) {
          filter.values.push(facetVal);
        } else {
          activeFilters.push({ name: checkboxGroupName, values: [facetVal] });
        }
      } else {
        if (filter) {
          filter.values = filter.values.filter((val) => val !== facetVal);
        }
        if (filter.values.length === 0) {
          activeFilters = activeFilters.filter(
            (f) => f.name !== checkboxGroupName,
          );
        }
      }
      // eslint-disable-next-line no-use-before-define
      fetchProductData();
    }
  };

  const handleResponse = (response, availableFacets) => {
    const resultsContainer = document.getElementById(RESULTS_CONTAINER_ID);
    const products = mapToPagesResponse(response.hits);
    const category = document
      .getElementById(PCP_CONTAINER_ID)
      .getAttribute('data-category');
    if (currentPage === 0) {
      resultsContainer.innerHTML = '';
    }

    products.forEach((product) => {
      product.category = category;
      const div = document.createElement('div');
      div.classList.add(
        'product-listing__product',
        'bg-white',
        'hover:scale-[1.02]',
        'overflow-hidden',
        'rounded-lg',
        'shadow-md',
        'transition-transform',
        'mx-[5px]'
      );
      div.innerHTML = getItemTemplate(product).trim();
      div.setAttribute("data-product-details",JSON.stringify(product));
      resultsContainer.appendChild(div);
    });

    if (initFilters) {
      const facetsUl = document.getElementById(FILTER_CONTAINER_ID);
      const facets = mapFacets(response.aggregations);

      Object.keys(facets).forEach((facetKey) => {
        const facetObject = availableFacets.find((item) => facetKey in item);
        if (facetObject) {
          const facetLabel = facetObject ? facetObject[facetKey] : '';
          const li = document.createElement('li');
          li.innerHTML = getFilterTemplate(
            facetKey,
            facets[facetKey],
            facetLabel,
          ).trim();
          facetsUl.appendChild(li);
        }
      });

      document.getElementById(PCP_CONTAINER_ID).onclick = (event) =>
        handleFilterChange(event);
      initFilters = false;
    }
    currentPage += 1;
    const loadMoreButton = document.getElementById(LOAD_MORE_BUTTON_ID);
    // eslint-disable-next-line no-unused-expressions
    response.hits.total.value > PER_PAGE * currentPage
      ? loadMoreButton.classList.remove('hidden')
      : loadMoreButton.classList.add('hidden');
  };

  const fetchProductData = () => {
    const category = document
      .getElementById(PCP_CONTAINER_ID)
      .getAttribute('data-category');
    const filterJSON = document
      .getElementById(PCP_CONTAINER_ID)
      .getAttribute('data-filters');
    let availableFacets = [];
    if (filterJSON) {
      availableFacets = JSON.parse(filterJSON);
    }

    fetch(SEARCH_URL, {
      body: buildQuery(category, availableFacets),
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      method: 'POST',
    })
      .then((response) => response.json())
      .then((response) => {
        handleResponse(response, availableFacets);
      }).then(()=> {
        //TODO: Event is probably fine, but need to add actual DM JS function eventually to codebase.
        document.dispatchEvent(new CustomEvent("resultsLoaded"));
      });
  };

  const init = () => {
    const pageIsPCP = document.getElementById(PCP_CONTAINER_ID);
    if (!pageIsPCP) {
      return;
    }
    const loadMoreButton = document.getElementById(LOAD_MORE_BUTTON_ID);
    loadMoreButton.addEventListener('click', () => {
      fetchProductData();
    });

    fetchProductData();
  };

  init();
})();