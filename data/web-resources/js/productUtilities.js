import { utilities } from "./graphQLMutations/utility.js";
import { cartMutations } from "./graphQLMutations/cartMutations.js";

const featuredProductsList = document.querySelectorAll('.product-listing__product');

const addProductToCart = async(sku, quantity) => {
    let cartID = utilities.getCartIDFromLS();
    if(!cartID){
        cartID = await cartMutations.generateCartID();
        utilities.setCartIDtoLS(cartID);
    }
    let cart = await cartMutations.addProductToCart(cartID, {sku, quantity});
    
    if(cart.errors){
        if(cart.errors[0].extensions?.category == 'graphql-authorization'){
            await userMutations.regenerateUserToken();
            cart = await cartMutations.addProductToCart(cartID,{sku, quantity});
        }
        console.log(cart.errors[0].message);
    }else{
        utilities.setCartQuantityToLS(cart.total_quantity);
        utilities.updateCartCountOnUI();
    }

}

featuredProductsList.forEach( featuredProductEle => {
    const productSKU = JSON.parse(featuredProductEle.dataset.productDetails).sku;
    const addToCartCTA = featuredProductEle.querySelector('.addToCart');
    addToCartCTA.addEventListener('click', () => { 
        addProductToCart(productSKU, 1)
    });
});
