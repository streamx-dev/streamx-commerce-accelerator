import { utilities } from "./graphQLMutations/utility";
import { cartMutations } from "./graphQLMutations/cartMutations";

const addProductToCart = async(sku, quantity) => {
    let cartID = utilities.getCartIDFromLS();
    if(!cartID){
        cartID = await cartMutations.generateCartID();
        utilities.setCartIDtoLS(cartID);
    }
    let cart = await cartMutations.addProductToCart(cartID, {sku, quantity});

    if(cart.errors.extensions.category == 'graphql-authorization'){
        await userMutations.regenerateUserToken();
        cart = await cartMutations.addProductToCart(cartID,{sku, quantity});
    }

    utilities.setCartQuantityToLS(cart.total_quantity);
    utilities.updateCartCountOnUI();
}

export const productUtils = {
    addProductToCart
};