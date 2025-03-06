//global vars
const GRAPHQL_ENDPOINT = `/graphql`;

const HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'mode': 'no-cors',
  'Content-Type': 'application/json',
  'store': 'lumax'
};

const user01 = {
  firstname: "prft",
  lastname: "lumax",
  email: "prft01@lumax.com",
  password: "prft@123",
  is_subscribed: true
}

const user02 = {
  firstname: "perficient",
  lastname: "lumax",
  email: "prft02@lumax.com",
  password: "prft@123",
  is_subscribed: true
}

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

  // getter setter - cartID on Local storage
const getCartIDFromLS = () => localStorage.getItem("shoppingCartID");
const setCartIDtoLS = (cartID) => localStorage.setItem("shoppingCartID", cartID);
const removeCartIDFromLS = () => localStorage.removeItem("shoppingCartID");

const getCartQuantityFromLS = () => localStorage.getItem("shoppingCartQuantity");
const setCartQuantityToLS = (quantity) => localStorage.setItem("shoppingCartQuantity", quantity);
const removeCartQuantityFromLS = () => localStorage.removeItem("shoppingCartQuantity");

// getter setter user token 
const getUser1TokenFromLS = () => localStorage.getItem("user1_token");
const setUser1TokentoLS = (userToken) => localStorage.setItem("user1_token", userToken);
const removeUser1TokenFromLS = () => localStorage.removeItem("user1_token");

const getUser2TokenFromLS = () => localStorage.getItem("user2_token");
const setUser2TokentoLS = (userToken) => localStorage.setItem("user2_token", userToken);
const removeUser2TokenFromLS = () => localStorage.removeItem("user2_token");

const getActiveUserFromLS = () => localStorage.getItem("active_user");
const setActiveUsertoLS = (user) => localStorage.setItem("active_user", user);
const removeActiveUserFromLS = () => localStorage.removeItem("active_user");

const getTokenFromLS = () => getActiveUserFromLS() == 'user01' ? getUser1TokenFromLS() : getUser2TokenFromLS();
const setTokentoLS = (userToken) => getActiveUserFromLS() == 'user01' ? setUser1TokentoLS(userToken) : setUser2TokentoLS(userToken); 
const removeTokenFromLS = () => getActiveUserFromLS() == 'user01' ? removeUser1TokenFromLS() : removeUser2TokenFromLS(); 

const updateCartCountOnUI = () => { 
  const cartQuantity = getCartQuantityFromLS(); 
  document.querySelector('.cart-quantity').innerText = cartQuantity ? cartQuantity : 0;
}

export const utilities = {
  GRAPHQL_ENDPOINT,
  HEADERS,
  user01,
  user02,
  fetchRequests,
  getCartIDFromLS,
  setCartIDtoLS,
  removeCartIDFromLS,
  getCartQuantityFromLS,
  setCartQuantityToLS,
  removeCartQuantityFromLS,
  getTokenFromLS,
  setTokentoLS,
  removeTokenFromLS,
  getActiveUserFromLS,
  setActiveUsertoLS,
  removeActiveUserFromLS,
  updateCartCountOnUI
} 