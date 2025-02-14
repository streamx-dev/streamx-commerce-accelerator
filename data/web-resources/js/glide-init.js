// eslint-disable-next-line func-names,no-unused-expressions
!(function () {
  // 1024px - default md breakpoint for tailwind
  // eslint-disable-next-line no-undef
  new Glide('.glide', {
    breakpoints: {
      1023: {
        perView: 1,
      },
    },
    gap: 40,
    perView: 2,
  }).mount();
})();
