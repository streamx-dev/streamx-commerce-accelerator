// eslint-disable-next-line no-unused-expressions,func-names
!(function () {
  const classToggle = (el, ...args) => args.map((e) => el.classList.toggle(e));
  const K_SPACE = ' ';
  const C_SPACE = 32;
  const K_ENTER = 'Enter';
  const C_ENTER = 13;

  function toggleMobileNavMenu() {
    const navMenuBurgerIcon = document.getElementsByClassName(
      'nav-menu-icon__burger',
    )[0];
    const navMenuCloseIcon = document.getElementsByClassName(
      'nav-menu-icon__close',
    )[0];
    const mobileMenu = document.getElementById('nav-menu');

    classToggle(navMenuBurgerIcon, 'block', 'hidden');
    classToggle(navMenuCloseIcon, 'block', 'hidden');
    classToggle(mobileMenu, 'block', 'hidden');
  }

  function init() {
    const navMenuMobileButton = document.getElementById('mobile-nav-button');

    if (navMenuMobileButton) {
      navMenuMobileButton.addEventListener('click', () => {
        toggleMobileNavMenu();
      });

      navMenuMobileButton.addEventListener('keydown', (e) => {
        const isKeyDown = e.type === 'keydown';
        const isEnter = e.code === K_ENTER || e.keyCode === C_ENTER;
        const isSpace = e.code === K_SPACE || e.keyCode === C_SPACE;
        if (isKeyDown && (isEnter || isSpace)) {
          toggleMobileNavMenu();
        }
      });
    }
  }

  init();
})();
