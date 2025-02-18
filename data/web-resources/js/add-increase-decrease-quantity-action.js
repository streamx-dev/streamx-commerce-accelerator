const addIncreaseDecreaseQuantityAction = () => {
  const quantityContainer = document.querySelector('.quantity-container');
  if (quantityContainer) {
    let quantity = parseInt(
      quantityContainer.querySelector('span')?.textContent ?? '1',
      10,
    );
    const decreaseQuantityButton = quantityContainer.querySelector(
      ':scope > button:nth-of-type(1)',
    );
    const increaseQuantityButton = quantityContainer.querySelector(
      ':scope > button:nth-of-type(2)',
    );
    decreaseQuantityButton?.addEventListener('click', () => {
      if (quantity > 1) {
        quantity -= 1;
        if (quantity === 1) {
          decreaseQuantityButton?.setAttribute('disabled', true.toString());
        }
      }
      quantityContainer.querySelector('span').innerText = quantity.toString();
    });
    increaseQuantityButton?.addEventListener('click', () => {
      if (quantity === 1) {
        decreaseQuantityButton?.removeAttribute('disabled');
      }
      quantity += 1;
      quantityContainer.querySelector('span').innerText = quantity.toString();
    });
  }
};
addIncreaseDecreaseQuantityAction();
