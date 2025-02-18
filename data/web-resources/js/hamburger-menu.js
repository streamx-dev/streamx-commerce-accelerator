const hamburgerButton = document.querySelector('.hamburger-menu');
const containerMobile = document.querySelector('.container-mobile');

if (hamburgerButton && containerMobile) {
  hamburgerButton.addEventListener('click', () => {
    if (containerMobile.classList.contains('hidden')) {
      containerMobile.classList.remove('hidden');
      containerMobile.classList.add('md:hidden');
    } else {
      containerMobile.classList.remove('md:hidden');
      containerMobile.classList.add('hidden');
    }
  });
}
