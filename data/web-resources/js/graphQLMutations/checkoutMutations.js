import { utilities } from "./utility.js";

//set shipping
const setShippingAddress = async (cartID, address) => {
  /* expected address format
  address: {
            firstname: "Bob"
            lastname: "Roll"
            company: "Magento"
            street: ["Magento Pkwy", "Main Street"]
            city: "Austin"
            region: "TX"
            postcode: "78758"
            country_code: "US"
            telephone: "8675309"
            save_in_address_book: true
          } 
  */
  const query = JSON.stringify({
    query: `mutation { setShippingAddressesOnCart( input: { cart_id: "${cartID}" shipping_addresses: [ { address: {firstname: ${address.firstname} lastname: ${address.lastname} company: "Magento" street: ${address.street} city: ${address.city} region: ${address.region} postcode: ${address.postcode} country_code: "US" telephone: ${address.telephone} save_in_address_book: ${address.save_in_address_book} } } ] } ) { cart { shipping_addresses { firstname lastname company street city region { code label } postcode telephone country { code label } pickup_location_code } } } }`,
  });

  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const setShippingAddResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return setShippingAddResponse.errors ? setShippingAddResponse : setShippingAddResponse.data.setShippingAddressesOnCart.cart;
}

//set billing address
const setBillingAddress = async (cartID, address, sameAsShipping) => {
   /* expected address format
  address: {
            firstname: "Bob"
            lastname: "Roll"
            company: "Magento"
            street: ["Magento Pkwy", "Main Street"]
            city: "Austin"
            region: "TX"
            postcode: "78758"
            country_code: "US"
            telephone: "8675309"
            save_in_address_book: true
          } 
  */
  const query = JSON.stringify({
    query: `mutation { setBillingAddressOnCart( input: { cart_id: "${cartID}" billing_address: { address: { firstname: ${address.firstname} lastname: ${address.lastname} company: "Magento" street: ${address.street} city: ${address.city} region: ${address.region} postcode: ${address.postcode} country_code: "US" telephone: ${address.telephone} save_in_address_book: ${address.save_in_address_book} } same_as_shipping:${sameAsShipping} } } ) { cart { billing_address { firstname lastname company street city region{ code label } postcode telephone country{ code label } } } } }`,
  });

  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const setBillingAddResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return setBillingAddResponse.errors ? setBillingAddResponse : setBillingAddResponse.data.setBillingAddressOnCart.cart;
}

//set shipping method
const setShippingMethod = async (cartID) => {
/* "shippingMethod": {
			"carrier_code": "flatrate",
			"method_code": "flatrate"
} */
let shippingMethodObj = {
  "carrier_code": "flatrate",
  "method_code": "flatrate"
}
  const query = JSON.stringify({
    query: `mutation { setShippingMethodsOnCart(input: { cart_id: "${cartID}" shipping_methods: [ { carrier_code: ${shippingMethodObj.carrier_code} method_code: ${shippingMethodObj.method_code} } } ] }) { cart { shipping_addresses { selected_shipping_method { carrier_code method_code carrier_title method_title } } } } }`,
  });

  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const setShippingMethodResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return setShippingMethodResponse.errors ? setShippingMethodResponse : setShippingMethodResponse.data.setShippingMethodsOnCart.cart;
}

//set payment method
const setPaymentMethod = async (cartID, paymentCode="checkmo") => {
  const query = JSON.stringify({
    query: `mutation { setPaymentMethodOnCart(input: { cart_id: "${cartID}" payment_method: { code: ${paymentCode} } }) { cart { selected_payment_method { code title } } } }`,
  });

  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const setPaymentMethodResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return setPaymentMethodResponse.errors ? setPaymentMethodResponse : setPaymentMethodResponse.data.setPaymentMethodOnCart.cart;
}

//place order
const placeOrder = async (cartID) => {
  const query = JSON.stringify({
    query: `mutation { placeOrder( input: { cart_id: "${cartID}" } ) { order { order_number } } }`,
  });
  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const placeOrderResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return placeOrderResponse.errors ?  placeOrderResponse : placeOrderResponse.data.placeOrder.order.order_number;
}

//set payment and place order
const setPaymentMethodandPlaceOrder = async (cartID, paymentCode="checkmo") => {
  const query = JSON.stringify({
    query: `mutation { setPaymentMethodAndPlaceOrder( input: { cart_id: "${cartID}" payment_method: { code: ${paymentCode} } } ) { order { order_id } } }`,
  });
  const header = utilities.getActiveUserFromLS() ? {...utilities.HEADERS, 'Authorization': `Bearer ${utilities.getTokenFromLS()}`} : utilities.HEADERS;
  const cartResponse = await utilities.fetchRequests(utilities.GRAPHQL_ENDPOINT, 'POST', header, query);
  return cartResponse.errors ? cartResponse : cartResponse.data.setPaymentMethodAndPlaceOrder.order.order_number;
}

export const checkoutMutations = {
  setShippingAddress,
  setBillingAddress,
  setShippingMethod,
  setPaymentMethod,
  placeOrder,
  setPaymentMethodandPlaceOrder
};