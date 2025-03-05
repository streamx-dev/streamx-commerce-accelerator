import { getTokenFromLS } from "./miscMutations.js";
import { utilities } from "./utility.js";

const CART_QUERY = `{ email billing_address { city country { code label } firstname lastname postcode region { code label } street telephone } shipping_addresses { firstname lastname street city region { code label } country { code label } telephone available_shipping_methods { amount { currency value } available carrier_code carrier_title error_message method_code method_title price_excl_tax { value currency } price_incl_tax { value currency } } selected_shipping_method { amount { value currency } carrier_code carrier_title method_code method_title } } items { id product { name sku image { url } thumbnail { url } } quantity prices { price { value currency } } } available_payment_methods { code title } selected_payment_method { code title } applied_coupons { code } prices { grand_total { value currency } } }`;

//createCartID query
const generateCartID = async () => {
  const query = JSON.stringify({
    query:  "mutation {createEmptyCart}",
    variables: {}
  });

  const createShoppingCartID = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', utilities.HEADERS, query);

  return createShoppingCartID.data.createEmptyCart;
}

//getCart query
const getCartByID = async (cartID) => {
  const query = JSON.stringify({
    query: `{ cart(cart_id: "${cartID}") ${CART_QUERY} }`,
  });

  const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.data.cart;
}

//add product
const addProductToCart = async (cartID, cartItems) => {
  const query = JSON.stringify({
    query: `mutation { addSimpleProductsToCart( input: { cart_id: ${cartID} cart_items: [ { data: { quantity: ${cartItems.quantity} sku: ${cartItems.sku} } } ] } ) { cart { items { id product { sku stock_status } quantity } } } }`,
  });

  const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart;
}

//update
const updateProductInCart = async (cartID, uid, quantity) => {
  const query = JSON.stringify({
    query: `mutation { updateCartItems( input: { cart_id: ${cartID}, cart_items: [ { cart_item_uid: ${uid} quantity: ${quantity} } ] } ){ cart { items { product { name } quantity } prices { grand_total{ value currency } } } } }`,
    variables: {},
  });

  const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart;
}

//delete
const removeItemFromCart = async (cartID, uid) => {
 const query = JSON.stringify({
    query: `mutation { removeItemFromCart( input: { cart_id: ${cartID}, cart_item_uid: ${uid} } ) { cart { items { uid id product { name } quantity } prices { grand_total{ value currency } } } } }`,
    variables: {},
 });

 const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart;
}


// Query for Logged in users
const mergeCarts = async (guestCartID, loggedinUserCartID) => {
  const query = JSON.stringify({
    query: `mutation { mergeCarts( source_cart_id: ${guestCartID}, destination_cart_id: ${loggedinUserCartID} ) { itemsV2 { items { id product { name sku } quantity } total_count } } }`,
    variables: {}
  });

  const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart;
}

const getCustomerCart = async () => {
  const query = JSON.stringify({
    query: `{ customerCart { id items { id product { name sku } quantity } } }`
  });

  const header = getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${getTokenFromLS()}`} : utilities.HEADERS;
  const userCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  
  return userCart.data.customerCart;
}

export const cartMutations = {
  generateCartID,
  getCartByID,
  addProductToCart,
  updateProductInCart,
  removeItemFromCart,
  getCustomerCart,
  mergeCarts
};

