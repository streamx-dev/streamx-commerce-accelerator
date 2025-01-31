!function() {
    const SEARCH_RESULTS_COUNT = 40;
    const SEARCH_URL = '/search/query';

    const buildUrl = (query, limit) => {
        return `${SEARCH_URL}?size=${limit}&query=${query}`;
    };
      
    const mapToPagesResponse = async (response)=> {
        const jsonResponse = await response.json();
        const items = jsonResponse.hits.hits ? jsonResponse.hits.hits.map(mapToPage) : [];
        return {
          items: items,
          executionTimeMs: jsonResponse.took
        };
    }

    const mapToPage = (hit) => {
        const path = hit._id;
        const score = hit._score;
        const title = hit.highlight?.["payload.title"]?.[0] || hit._source.payload.title;
        const bestFragment = hit.highlight?.["payload.content"]?.[0] || title || "";

        return {
            path,
            title,
            bestFragment,
            score
        };
    };

    const getPages = async (query) => {
        const response = await fetch(buildUrl(query, SEARCH_RESULTS_COUNT));
        return mapToPagesResponse(response);
    };

    const getAutocompleteItemUrl = (item) => {
        return (item && item.path) ? item.path : "";
    };

    const getItemTemplate = (html, item) => {
        return html`<a class="aa-ItemLink" href=${getAutocompleteItemUrl(item)}>
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
                        dangerouslySetInnerHTML="${ item.title }"
                    ></div>
                    <div
                        class="aa-ItemContentDescription"
                        dangerouslySetInnerHTML="${ item.bestFragment }"
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
            container: '#autocomplete',
            placeholder: "Search...",
            detachedMediaQuery: "",
            openOnFocus: true,
            getSources({ query }) {
                return [
                  {
                    sourceId: "pages",
                    async getItems({ query }) {
                      if (query === "") {
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
                        query === ""
                          ? undefined
                          : () => {
                              return "No results";
                            },
                    },
                  }
                ]
              },
          });
    }

    init();
}();
