// getter setter - cartID on Local storage
export const getCartIDFromLS = () => localStorage.getItem("shoppingCartID");
const setCartIDtoLS = (cartID) => localStorage.setItem("shoppingCartID", cartID);
const removeCartIDFromLS = () => localStorage.removeItem("shoppingCartID");

const getCartQuantityFromLS = () => localStorage.getItem("shoppingCartQuantity");
const setCartQuantityFromLS = (quantity) => localStorage.setItem("shoppingCartQuantity", quantity);
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

export const getTokenFromLS = () => getActiveUserFromLS() == 'user1' ? getUser1TokenFromLS() : getUser2TokenFromLS();
const setTokentoLS = (user) => getActiveUserFromLS() == 'user1' ? setUser1TokentoLS(user) : setUser2TokentoLS(user); 
const removeTokenFromLS = () => getActiveUserFromLS() == 'user1' ? removeUser1TokenFromLS() : removeUser2TokenFromLS(); 


export const miscMutations = {
  getCountries,
  getRegionsByCountry,
  getCartIDFromLS,
  setCartIDtoLS,
  removeCartIDFromLS,
  getCartQuantityFromLS,
  setCartQuantityFromLS,
  removeCartQuantityFromLS,
  getTokenFromLS,
  setTokentoLS,
  removeTokenFromLS,
  setActiveUsertoLS,
  removeActiveUserFromLS
} 