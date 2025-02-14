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
swapImageAction();
