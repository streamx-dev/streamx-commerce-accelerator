import { utilities } from './graphQLMutations/utility';
import { cartMutations } from './graphQLMutations/cartMutations';

const updateToken = async () => {
    if(!getTokenFromLS()){ 
        const token = await userMutations.getUserToken(); 
        utilities.setTokentoLS(token)
    }
}

const updateCartCountOnUI = () => { 
    const cartQuantity = localStorage.getItem('shoppingCartQuantity'); 
    document.querySelector('.cart-quantity').innerText = cartQuantity ? cartQuantity : 0;
}

const updateCartDetailsOnLoad = async(isLoggedIn=false) => {
    if(isLoggedIn){
        const cartID = utilities.getCartIDFromLS(); 
        if(cartID) {
            const cart = await cartMutations.getCustomerCart(); 
            if(cart.ID !== cartID) {
                const newCart = await cartMutations.mergeCarts(cartID, cart.ID)
                utilities.setCartIDtoLS(cart.ID); 
                utilities.setCartQuantityToLS(newCart.itemsV2.total_count);
            }
        }
    }
    updateCartCountOnUI(); 
}

const onLoginHandler = async (activeUser) =>{
    utilities.setActiveUsertoLS(activeUser);

    await updateToken();
    await updateCartDetailsOnLoad(true);
}

const onLogoutHandler = () =>{
    utilities.removeCartQuantityFromLS();
    utilities.removeActiveUserFromLS();
    updateCartDetailsOnLoad();
}


export const headerUtilities = {
    onLoginHandler,
    onLogoutHandler
}