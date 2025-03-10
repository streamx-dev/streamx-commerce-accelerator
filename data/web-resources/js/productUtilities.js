import { utilities } from "./graphQLMutations/utility.js";
import { cartMutations } from "./graphQLMutations/cartMutations.js";
import { userMutations } from "./graphQLMutations/userMutations.js";


export const addProductToCart = async (sku, quantity) => {
    let cartID = utilities.getCartIDFromLS();
    if (!cartID) {
        cartID = await cartMutations.generateCartID();
        utilities.setCartIDtoLS(cartID);
    }
    let cart = await cartMutations.addProductToCart(cartID, { sku, quantity });

    if (cart.errors) {
        if (cart.errors[0].extensions?.category == 'graphql-authorization') {
            await userMutations.regenerateUserToken();
            cart = await cartMutations.addProductToCart(cartID, { sku, quantity });
        }
        console.log(cart.errors[0].message);
    } else {
        utilities.setCartQuantityToLS(cart.total_quantity);
        utilities.updateCartCountOnUI();
    }
}

//for featured products add to cart fucntion
const featuredProductsList = document.querySelectorAll('.product-listing__product');
featuredProductsList?.forEach(featuredProductEle => {
    const productSKU = JSON.parse(featuredProductEle.dataset.productDetails).sku;
    console.log("ProductSku");
    console.log(productSKU);

    const addToCartCTA = featuredProductEle.querySelector('.addToCart');
    addToCartCTA.addEventListener('click', () => {
        console.log("CTA clicked");

        addProductToCart(productSKU, 1)
    });
});



export const removeItemFromCart = async(cartID, uid) => {
    const response = await cartMutations.removeItemFromCart(cartID, uid);

    if (response.errors) {
        if (response.errors[0].extensions?.category == 'graphql-authorization') {
            await userMutations.regenerateUserToken();
            cart = await cartMutations.removeItemFromCart(cartID, uid);
        }
        console.log(cart.errors[0].message);
    } else {
        utilities.setCartQuantityToLS(response.total_quantity);
        utilities.updateCartCountOnUI();
    }
}

export const updateItemQuantityInCart = async(cartID, uid, quantity) => {
    const response = await cartMutations.updateProductInCart(cartID, uid, quantity);

    if (response.errors) {
        if (response.errors[0].extensions?.category == 'graphql-authorization') {
            await userMutations.regenerateUserToken();
            cart = await cartMutations.updateProductInCart(cartID, uid, quantity);
        }
        console.log(cart.errors[0].message);
    } else {
        utilities.setCartQuantityToLS(response.total_quantity);
        utilities.updateCartCountOnUI();
    }
}

export const fetchCartByID = async(cartID) => {
    const response = await cartMutations.getCartByID(cartID);

    if (response.errors) {
        if (response.errors[0].extensions?.category == 'graphql-authorization') {
            await userMutations.regenerateUserToken();
            cart = await cartMutations.getCartByID(cartID);;
        }
        console.log(cart.errors[0].message);
        return false;
    } else {
        utilities.setCartQuantityToLS(response.total_quantity);
        utilities.updateCartCountOnUI();
        return response;
    }
}
