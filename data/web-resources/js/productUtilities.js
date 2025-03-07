import { utilities } from "./graphQLMutations/utility.js";
import { cartMutations } from "./graphQLMutations/cartMutations.js";
import { userMutations } from "./graphQLMutations/userMutations.js";

const featuredProductsList = document.querySelectorAll('.product-listing__product');

const addProductToCart = async (sku, quantity) => {
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

featuredProductsList.forEach(featuredProductEle => {
    const productSKU = JSON.parse(featuredProductEle.dataset.productDetails).sku;
    const addToCartCTA = featuredProductEle.querySelector('.addToCart');
    addToCartCTA.addEventListener('click', () => {
        addProductToCart(productSKU, 1)
    });
});

const updateSubtotalPriceItem = (quantity, price) => {
    return quantity * price;
}

const itemTemplate = (item) => `
<div class="flex items-center space-x-4" data-uid="${item.uid}"><a class="shrink-0"
        href="/products/${item.product.sku}" data-discover="true"><img
            src="${item.product.thumbnail.url}" alt="${item.product.name}"
            class="w-24 h-24 object-cover rounded-sm"></a>
    <div class="flex-1"><a href="/products/${item.product.sku}" data-discover="true">
            <h3 class="font-semibold text-lg mb-1">${item.product.name}</h3>
        </a>
        <p class="text-gray-600 mb-2 price"><span>$</span><span class="value">${item.prices.price.value}</span>
        </p>
        <div class="flex items-center space-x-4 actions-container">
            <div class="flex items-center space-x-2 quantity-container">
                <button
                    class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 w-10">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round"
                        class="lucide lucide-minus h-4 w-4">
                        <path d="M5 12h14"></path>
                    </svg>
                </button>
                <span class="w-8 text-center">${item.quantity}</span>
                <button
                    class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 w-10">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round"
                        class="lucide lucide-plus h-4 w-4">
                        <path d="M5 12h14"></path>
                        <path d="M12 5v14"></path>
                    </svg>
                </button>
            </div>
            <button
                class="remove-item inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 hover:bg-accent hover:text-accent-foreground h-10 w-10">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                    stroke-linejoin="round" class="lucide lucide-trash2 h-4 w-4 text-red-500">
                    <path d="M3 6h18"></path>
                    <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                    <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                    <line x1="10" x2="10" y1="11" y2="17"></line>
                    <line x1="14" x2="14" y1="11" y2="17"></line>
                </svg>
            </button>
        </div>
    </div>
    <div class="text-right">
        <p class="font-semibold text-lg"><span>$</span><span class="subtotal-item">${updateSubtotalPriceItem(item.quantity, item.prices.price.value)}</span></p>
    </div>
</div>`;

const updatePrice = async (el, price, quantity) => {
    const cartID = utilities.getCartIDFromLS();

    const uid = el.closest(".item > div").dataset.uid;
    cartMutations.updateProductInCart(cartID, uid, quantity);

    el.closest(".item").querySelector(".subtotal-item").innerHTML = updateSubtotalPriceItem(quantity, price);

    const subtotal = document.querySelectorAll(".item:not(.hidden) .subtotal-item");
    let total = 0;
    if (subtotal) {
        subtotal.forEach((el) => {
            const value = el.textContent;
            if (value) {
                total += parseInt(value);
            }
        });
        document.querySelector('.subtotal').innerHTML = document.querySelector('.total').innerHTML = total;
    }
}

const removeItem = (cartID) => {
    const removeItemButton = document.querySelectorAll('.remove-item');

    if (removeItemButton) {
        removeItemButton.forEach((el) => {
            el.addEventListener('click', async () => {
                const price = el.closest(".actions-container").previousElementSibling.querySelector(".value").textContent;
                updatePrice(el, price, 0);
                const uid = el.closest(".item > div").dataset.uid;
                el.closest('.item').remove();
                const response = await cartMutations.removeItemFromCart(cartID, uid);
                console.log(response);
                if (response.total_quantity == 0) {
                    document.querySelector('.no-products').classList.remove('hidden');
                    document.querySelector('.shopping-cart-content').classList.add('hidden');
                    document.querySelector('.shipping-information-content').classList.add('hidden');
                    document.querySelector('.loading-message').classList.remove('hidden');
                }
            });
        });

    }
};

const addIncreaseDecreaseQuantityAction = () => {
    const quantityContainer = document.querySelectorAll('.quantity-container');
    if (quantityContainer) {
        quantityContainer.forEach((el) => {
            const price = el.closest(".actions-container").previousElementSibling.querySelector(".value").textContent;

            let quantity = parseInt(
                el.querySelector('span')?.textContent ?? '1',
                10,
            );
            const decreaseQuantityButton = el.querySelector(
                ':scope > button:nth-of-type(1)',
            );
            const increaseQuantityButton = el.querySelector(
                ':scope > button:nth-of-type(2)',
            );
            decreaseQuantityButton.addEventListener('click', () => {
                if (quantity > 1) {
                    quantity -= 1;
                    if (quantity === 1) {
                        decreaseQuantityButton.setAttribute('disabled', true.toString());
                    }
                    if (price) {
                        updatePrice(el, parseInt(price), quantity);
                    }
                }
                el.querySelector('span').innerText = quantity;
            });
            increaseQuantityButton.addEventListener('click', () => {
                if (quantity === 1) {
                    decreaseQuantityButton.removeAttribute('disabled');
                }
                quantity += 1;
                el.querySelector('span').innerText = quantity;
                if (price) {
                    updatePrice(el, parseInt(price), quantity);
                }
            });
        });
    }
};

async function updateCartPage() {
    // utilities.setCartIDtoLS("M1a2nvO253QEC1kDOYghjTSePf6iXpjv");
    const cartID = utilities.getCartIDFromLS();

    if (cartID == null) {
        document.querySelector('.no-products').classList.remove('hidden');
    } else {
        document.querySelector('.loading-message').classList.remove('hidden');
        let cart = await cartMutations.getCartByID(cartID);

        if (cart.errors) {
            if (cart.errors[0].extensions?.category == 'graphql-authorization') {
                await userMutations.regenerateUserToken();
                cart = await cartMutations.getCartByID(cartID);
            }
            console.log(cart.errors[0].message);
        }
        if (cart.items.length == 0) {
            document.querySelector('.no-products').classList.remove('hidden');
            document.querySelector('.loading-message').classList.add('hidden');
        } else {
            document.querySelector('.shopping-cart-content').classList.remove('hidden');
            document.querySelector('.shipping-information-content').classList.remove('hidden');
            document.querySelector('.loading-message').classList.add('hidden');

            const items = cart.items;
            const itemsContainer = document.querySelector('.cart-items-container');
            items.forEach((item) => {
                const div = document.createElement('div');
                div.classList.add(
                    'p-6',
                    'item',
                );
                div.innerHTML = itemTemplate(item).trim();
                itemsContainer.appendChild(div);
            });
            addIncreaseDecreaseQuantityAction();

            document.querySelector('.subtotal').innerText = cart.prices.subtotal_excluding_tax.value;
            document.querySelector('.tax').innerText = cart.prices.subtotal_including_tax.value - cart.prices.subtotal_excluding_tax.value;
            document.querySelector('.shipping').innerText = cart.shipping_addresses[0] ? cart.shipping_addresses[0].available_shipping_methods.amount.value : 0;
            document.querySelector('.total').innerText = cart.prices.subtotal_including_tax.value;

            removeItem(cartID);
        }
    }
}

window.addEventListener('DOMContentLoaded', () => {
    updateCartPage();
});
