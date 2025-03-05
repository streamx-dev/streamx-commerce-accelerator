import { utilities } from "./utility.js";

const CART_QUERY = `{email billing_address { city country { code label } firstname lastname postcode region { code label } street telephone } shipping_addresses { firstname lastname street city region { code label } country { code label } telephone available_shipping_methods { amount { currency value } available carrier_code carrier_title error_message method_code method_title price_excl_tax { value currency } price_incl_tax { value currency } } selected_shipping_method { amount { value currency } carrier_code carrier_title method_code method_title } } items { uid id product { name sku image { url } thumbnail { url } } quantity prices { price { value currency } } } available_payment_methods { code title } selected_payment_method { code title } applied_coupons { code } prices { grand_total { value currency } applied_taxes { label amount { value } } subtotal_excluding_tax { value } subtotal_including_tax { value } } }`;

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

  const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.errors ? shoppingCart : shoppingCart.data.cart;
}

//add product
const addProductToCart = async (cartID, cartItems) => {
  const query = JSON.stringify({
    query: `mutation { addSimpleProductsToCart( input: { cart_id: "${cartID}" cart_items: [ { data: { quantity: ${cartItems.quantity} sku: "${cartItems.sku}" } } ] } ) { cart { items { id product { sku stock_status } quantity } } } }`,
  });

  const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.errors ? shoppingCart : shoppingCart.data.addSimpleProductsToCart.cart;
}

//update
const updateProductInCart = async (cartID, uid, quantity) => {
  const query = JSON.stringify({
    query: `mutation { updateCartItems( input: { cart_id: "${cartID}", cart_items: [ { cart_item_uid: "${uid}" quantity: ${quantity} } ] } ){ cart { items { product { name } quantity } prices { grand_total{ value currency } } } } }`,
    variables: {},
  });

  const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.errors ? shoppingCart : shoppingCart.data.updateCartItems.cart;
}

//delete
const removeItemFromCart = async (cartID, uid) => {
 const query = JSON.stringify({
    query: `mutation { removeItemFromCart( input: { cart_id: "${cartID}", cart_item_uid: "${uid}" } ) { cart { items { uid id product { name } quantity } prices { grand_total{ value currency } } } } }`,
    variables: {},
 });

 const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.errors ? shoppingCart : shoppingCart.data.removeItemFromCart.cart;
}


// Query for Logged in users
const mergeCarts = async (guestCartID, loggedinUserCartID) => {
  const query = JSON.stringify({
    query: `mutation { mergeCarts( source_cart_id: "${guestCartID}", destination_cart_id: "${loggedinUserCartID}" ) { itemsV2 { items { id product { name sku } quantity } total_count } } }`,
    variables: {}
  });

  const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const shoppingCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);

  return shoppingCart.errors ? shoppingCart : shoppingCart.data.mergeCarts;
}

const getCustomerCart = async () => {
  const query = JSON.stringify({
    query: `{ customerCart { id items { id product { name sku } quantity } } }`
  });

  const header = utilities.getTokenFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const userCart = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  
  return userCart.errors ? userCart : userCart.data.customerCart;
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

