const changeView = () => {
  const changeViewButtons = document.querySelectorAll('.button-view');
  const productListing = document.querySelector('.product-listing');
  if (changeViewButtons) {
    Array.from(changeViewButtons).forEach((changeViewButton) => {
      changeViewButton.addEventListener('click', (event) => {
        const { target } = event;
        let button = target;
        if (target.tagName !== 'BUTTON') {
          button = target.closest('.button-view');
        }
        let sibling;
        const index = [...button.parentElement.children].indexOf(button);
        if (index === 0) {
          sibling = button.nextElementSibling;
          productListing.classList.remove('product-listing--vertical');
          productListing.classList.add('product-listing--horizontal');
        } else {
          sibling = button.previousElementSibling;
          productListing.classList.remove('product-listing--horizontal');
          productListing.classList.add('product-listing--vertical');
        }
        if (button.dataset.state === 'on') {
          button.dataset.state = 'off';
          button.setAttribute('aria-pressed', 'false');
          if (sibling) {
            sibling.dataset.state = 'on';
            sibling.setAttribute('aria-pressed', 'true');
          }
        } else {
          button.dataset.state = 'on';
          button.setAttribute('aria-pressed', 'true');
          if (sibling) {
            sibling.dataset.state = 'off';
            sibling.setAttribute('aria-pressed', 'false');
          }
        }
      });
    });
  }
};

changeView();
