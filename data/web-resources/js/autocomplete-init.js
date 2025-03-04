!(function () {
  const SEARCH_RESULTS_COUNT = 40;
  const SEARCH_URL = '/search/query';

  const buildUrl = (query, limit) => {
    return `${SEARCH_URL}?size=${limit}&query=${query}`;
  };

  const mapToPagesResponse = async (response) => {
    const jsonResponse = await response.json();
    const items = jsonResponse.hits.hits
      ? jsonResponse.hits.hits.map(mapToPage)
      : [];
    return {
      items: items,
      executionTimeMs: jsonResponse.took,
    };
  };

  const mapToPage = (hit) => {
    const path = hit._id;
    const score = hit._score;
    const title =
      hit.highlight?.['payload.title']?.[0] || hit._source.payload.title;
    const bestFragment = hit.highlight?.['payload.content']?.[0] || title || '';

    return {
      path,
      title,
      bestFragment,
      score,
    };
  };

  const getPages = async (query) => {
    const response = await fetch(buildUrl(query, SEARCH_RESULTS_COUNT));
    return mapToPagesResponse(response);
  };

  const getAutocompleteItemUrl = (item) => {
    return item && item.path ? item.path : '';
  };

  const replaceEmWithMark = (value) => {
    if (typeof value !== 'string') return value;
    return value.replace(/<em>/g, '<mark>').replace(/<\/em>/g, '</mark>');
  };

  const getPantsResults = async () => {
    const response = await fetch(buildUrl('pants', 2));
    return mapToPagesResponse(response);
  };

  const getTeesResults = async () => {
    const response = await fetch(buildUrl('tees', 2));
    return mapToPagesResponse(response);
  };

  const getHoodiesResults = async () => {
    const response = await fetch(buildUrl('hoodies', 2));
    return mapToPagesResponse(response);
  };

  const getItemTemplate = (html, item) => {
    return html`<a class="searchResult aa-ItemLink" href=${getAutocompleteItemUrl(item)}>
      <div class="aa-ItemContent">
        <div class="aa-ItemIcon aa-ItemIcon--alignTop">
          <svg
            aria-labelledby="title"
            viewBox="0 0 24 24"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke="currentColor"
            stroke-width="2"
            class="block h-full w-auto"
            role="img"
          >
            <title id="title">Guide</title>
            <path
              d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"
            ></path>
            <polyline points="13 2 13 9 20 9"></polyline>
          </svg>
        </div>
        <div class="aa-ItemContentBody">
          <div
            class="aa-ItemContentTitle"
            dangerouslySetInnerHTML=${{ __html: replaceEmWithMark(item.title) }}
          ></div>
          <div
            class="aa-ItemContentDescription"
            dangerouslySetInnerHTML=${{
              __html: replaceEmWithMark(item.bestFragment),
            }}
          ></div>
        </div>
        <div class="aa-ItemActions">
          <button class="aa-ItemActionButton" type="button" title="Add to cart">
            <svg
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <polyline points="9 10 4 15 9 20"></polyline>
              <path d="M20 4v7a4 4 0 0 1-4 4H4"></path>
            </svg>
          </button>
        </div>
      </div>
    </a>`;
  };

  function init() {
    const { autocomplete } = window['@algolia/autocomplete-js'];
    autocomplete({
      classNames: {
        root: 'autocomplete__container',
        detachedSearchButton: [
          '[&_svg]:pointer-events-none',
          '[&_svg]:shrink-0',
          '[&_svg]:size-4',
          'autocomplete__search-button',
        ].join(' '),
      },
      container: '.autocomplete',
      placeholder: 'Search...',
      detachedMediaQuery: '',
      openOnFocus: true,
      getSources({ query }) {
        return [
          {
            sourceId: 'pages',
            async getItems({ query }) {
              if (query === '') {
                return [];
              }
              const pages = await getPages(query);
              return pages.items;
            },
            getItemUrl({ item }) {
              return getAutocompleteItemUrl(item);
            },
            templates: {
              item({ item, html }) {
                return getItemTemplate(html, item);
              },
              noResults:
                query === ''
                  ? undefined
                  : () => {
                      return 'No results';
                    },
            },
          },
          {
            sourceId: 'hoddiesResults',
            async getItems({ query }) {
              if (query) {
                return [];
              }
              const response = await getHoodiesResults();
              return response.items;
            },
            getItemUrl({ item }) {
              return getAutocompleteItemUrl(item);
            },
            templates: {
              header({ html }) {
                if (query === '') {
                  return html`<span class="aa-SourceHeaderTitle"
                      >Hoodies</span
                    >
                    <div class="aa-SourceHeaderLine" />`;
                }
                return null;
              },
              item({ item, html }) {
                return getItemTemplate(html, item);
              },
            },
          },
          {
            sourceId: 'pantsResults',
            async getItems({ query }) {
              if (query) {
                return [];
              }
              const response = await getPantsResults();
              return response.items;
            },
            getItemUrl({ item }) {
              return getAutocompleteItemUrl(item);
            },
            templates: {
              header({ html }) {
                if (query === '') {
                  return html`<span class="aa-SourceHeaderTitle"
                      >Pants</span
                    >
                    <div class="aa-SourceHeaderLine" />`;
                }
                return null;
              },
              item({ item, html }) {
                return getItemTemplate(html, item);
              },
            },
          },
          {
            sourceId: 'teesResults',
            async getItems({ query }) {
              if (query) {
                return [];
              }
              const response = await getTeesResults();
              return response.items;
            },
            getItemUrl({ item }) {
              return getAutocompleteItemUrl(item);
            },
            templates: {
              header({ html }) {
                if (query === '') {
                  return html`<span class="aa-SourceHeaderTitle"
                      >Tees</span
                    >
                    <div class="aa-SourceHeaderLine" />`;
                }
                return null;
              },
              item({ item, html }) {
                return getItemTemplate(html, item);
              },
            },
          },
        ];
      },
    });
  }

  const addTailwindIconToAutocomplete = (records) => {
    for (const record of records) {
      if (record.type === 'childList') {
        Array.from(record.addedNodes).forEach((node) => {
          if (node.classList.contains('autocomplete__container')) {
            const searchButton = node.querySelector(
              '.autocomplete__search-button',
            );
            if (searchButton) {
              const searchIcon = document.createElementNS(
                'http://www.w3.org/2000/svg',
                'svg',
              );
              searchIcon.setAttribute('height', '24');
              searchIcon.setAttribute('width', '24');
              searchIcon.setAttribute('viewBox', '0 0 24 24');
              searchIcon.setAttribute('fill', 'none');
              searchIcon.setAttribute('stroke', 'currentColor');
              searchIcon.setAttribute('stroke-linecap', 'round');
              searchIcon.setAttribute('stroke-linejoin', 'round');
              searchIcon.setAttribute('stroke-width', '2');
              searchIcon.classList.add(
                ...['lucide', 'lucide-search', 'h-5', 'w-5'],
              );

              const searchCircle = document.createElementNS(
                'http://www.w3.org/2000/svg',
                'circle',
              );
              searchCircle.setAttribute('cx', '11');
              searchCircle.setAttribute('cy', '11');
              searchCircle.setAttribute('r', '8');

              const searchPath = document.createElementNS(
                'http://www.w3.org/2000/svg',
                'path',
              );
              searchPath.setAttribute('d', 'm21 21-4.3-4.3');

              searchIcon.append(searchCircle);
              searchIcon.append(searchPath);
              searchButton.appendChild(searchIcon);
            }
          }
        });
      }
    }
  };

  const observer = new MutationObserver(addTailwindIconToAutocomplete);
  const autocompleteContainer = document.querySelector('.autocomplete');

  if (autocompleteContainer) {
    while (autocompleteContainer.firstChild) {
      autocompleteContainer.removeChild(autocompleteContainer.firstChild);
    }
    observer.observe(autocompleteContainer, {
      childList: true,
    });
  }

  init();
})();
