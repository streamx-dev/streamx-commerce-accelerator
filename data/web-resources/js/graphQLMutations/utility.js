//global vars
const GRAPHQL_ENDPOINT = `/graphql`;

const HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'mode': 'no-cors',
  'Content-Type': 'application/json',
  'store': 'lumax'
};

const fetchRequests = async (url, method, headers, body) => {
    const requestOptions = {
      method,
      headers,
      body,
      redirect: 'follow',
    };
    const response = await fetch(url, requestOptions);
    return await response.json();
}

export const utilities = {
    GRAPHQL_ENDPOINT,
    HEADERS,
    fetchRequests,
  };