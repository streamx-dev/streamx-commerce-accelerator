// eslint-disable-next-line func-names,no-unused-expressions
!(function () {
  const formatter = new Intl.NumberFormat('en-US', {
    currency: 'USD',
    style: 'currency',
  });

  const swapImageAction = () => {
    const mainImage = document.querySelector('.main-image');
    const imageListContainer = document.querySelector('.image-list-container');
    if (mainImage && imageListContainer) {
      const handleMouseEnter = (event) => {
        const { target } = event;
        const { alt, src } = target;
        mainImage.alt = alt;
        mainImage.src = src;
      };
      const imageList = [
        ...imageListContainer.getElementsByClassName('image-list-item'),
      ];
      imageList.forEach((item) => {
        item.addEventListener('mouseenter', handleMouseEnter);
        item.addEventListener('click', handleMouseEnter);
      });
    }
  };

  const buildPriceAssociativeArray = (prices) => {
    const pricesAsArray = prices.split(',');
    const pricesAssociative = [];
    pricesAsArray.forEach((price) => {
      // eslint-disable-next-line prefer-const
      let [value, ...key] = price.split(':');
      key = key.join(':');
      pricesAssociative[key] = value;
    });
    return pricesAssociative;
  };

  const addSwatchButtonActions = (
    swatchButtons,
    priceAssociativeArray,
    baseSku,
  ) => {
    Array.from(swatchButtons).forEach((swatchButton) => {
      swatchButton.addEventListener('click', (event) => {
        const activeButton =
          event.target.parentElement.querySelector('.active');
        if (activeButton) {
          activeButton.classList.remove('active');
          activeButton.classList.remove('border-black');
          activeButton.classList.add('border-transparent');
        }
        event.target.classList.add('active');
        event.target.classList.add('border-black');
        event.target.classList.remove('border-transparent');
        const selectedColor = event.target.getAttribute('title');
        const thumbnail = document.querySelector(
          `.image-list-container div[data-color="${selectedColor}"] .image-list-item`,
        );
        if (thumbnail) {
          thumbnail.click();
        }

        let selectedSize;
        let price;
        const sizeButtons = document.querySelectorAll('.size-buttons button');
        if (sizeButtons.length) {
          const activeSizeButton =
            document.querySelector('.size-buttons button.active') ||
            sizeButtons[0];
          selectedSize = activeSizeButton.textContent.trim();
          price = priceAssociativeArray[`${selectedColor}:${selectedSize}`];
        } else {
          price = priceAssociativeArray[`${selectedColor}`];
        }
        const pricesParagraph = document.querySelector('p[data-prices]');
        if (price && pricesParagraph) {
          pricesParagraph.innerText = formatter.format(price);
        }
        let newSku = baseSku;
        if (selectedSize) {
          newSku = `${newSku}-${selectedSize}`;
        }
        newSku = `${newSku}-${selectedColor}`;
        document.body.dataset.sku = newSku;
      });
    });
  };

  const addSizeButtonActions = (
    sizeButtons,
    priceAssociativeArray,
    baseSku,
  ) => {
    Array.from(sizeButtons).forEach((sizeButton) => {
      sizeButton.addEventListener('click', (event) => {
        const activeButton =
          event.target.parentElement.querySelector('.active');
        if (activeButton) {
          activeButton.classList.remove('active');
          activeButton.classList.remove('border-2');
          activeButton.classList.remove('border-black');
          activeButton.classList.add('border-input');
        }
        event.target.classList.add('active');
        event.target.classList.add('border-2');
        event.target.classList.add('border-black');
        event.target.classList.remove('border-input');
        const selectedSize = event.target.textContent.trim();

        let selectedColor;
        let price;

        const swatchButtons = document.querySelectorAll(
          '.swatch-buttons button',
        );
        if (swatchButtons.length) {
          const activeSwatchButton =
            document.querySelector('.swatch-buttons button.active') ||
            swatchButtons[0];
          selectedColor = activeSwatchButton.getAttribute('title');
          price = priceAssociativeArray[`${selectedColor}:${selectedSize}`];
        } else {
          price = priceAssociativeArray[`${selectedSize}`];
        }
        const pricesParagraph = document.querySelector('p[data-prices]');
        if (pricesParagraph) {
          pricesParagraph.innerText = formatter.format(price);
        }
        let newSku = `${baseSku}-${selectedSize}`;
        if (selectedColor) {
          newSku = `${newSku}-${selectedColor}`;
        }
        document.body.dataset.sku = newSku;
      });
    });
  };

  const setDefaultSwatchAndPrice = (swatchButtons, sizeButtons) => {
    if (swatchButtons && swatchButtons.length) {
      const swatchButton = swatchButtons[0];
      swatchButton.click();
    }

    if (sizeButtons && sizeButtons.length) {
      const sizeButton = sizeButtons[0];
      sizeButton.click();
    }
  };

  const init = () => {
    swapImageAction();
    const { baseSku } = document.body.dataset;
    const pricesParagraph = document.querySelector('p[data-prices]');
    const swatchButtons = document.querySelectorAll('.swatch-buttons button');
    const sizeButtons = document.querySelectorAll('.size-buttons button');
    if (pricesParagraph) {
      const { prices } = pricesParagraph.dataset;
      const priceAssociativeArray = buildPriceAssociativeArray(prices);
      addSwatchButtonActions(swatchButtons, priceAssociativeArray, baseSku);
      addSizeButtonActions(sizeButtons, priceAssociativeArray, baseSku);
      setDefaultSwatchAndPrice(swatchButtons, sizeButtons, baseSku);
    }
  };
  init();
})();
