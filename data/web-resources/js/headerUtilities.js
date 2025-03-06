import { utilities } from './graphQLMutations/utility.js';
import { cartMutations } from './graphQLMutations/cartMutations.js';

const updateToken = async () => {
    if(!utilities.getTokenFromLS()){ 
        const token = await userMutations.getUserToken(); 
        utilities.setTokentoLS(token)
    }
}

const updateCartDetailsOnLoad = async(isLoggedIn=false) => {
    if(isLoggedIn){
        let cartQuantity = 0;
        const cartID = utilities.getCartIDFromLS(); 
        const cart = await cartMutations.getCustomerCart();

        if(cart.errors.extensions.category == 'graphql-authorization'){
            await userMutations.regenerateUserToken();
            cart = await cartMutations.getCustomerCart();
        }

        if(cartID && cart && cart.ID !== cartID) {
            const newCart = await cartMutations.mergeCarts(cartID, cart.ID)
            utilities.setCartIDtoLS(cart.ID); 
            cartQuantity = newCart.itemsV2.total_count;
        }else if(cart.total_quantity){
            cartQuantity = cart.total_quantity;
        }
        utilities.setCartQuantityToLS(cartQuantity);
    }
    utilities.updateCartCountOnUI(); 
}

const onLoginHandler = async (activeUser) =>{
    utilities.setActiveUsertoLS(activeUser);

    await updateToken();
    await updateCartDetailsOnLoad(true);
}

const onLogoutHandler = () =>{
    utilities.removeCartQuantityFromLS();
    utilities.removeActiveUserFromLS();
    utilities.removeCartIDFromLS();
    updateCartDetailsOnLoad();
}


export const headerUtilities = {
    onLoginHandler,
    onLogoutHandler
}