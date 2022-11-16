/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{html,js,erb}"],
  theme: {
    extend: {
      colors: {
        main: {
          'default': "#60b0e2",
          "500": "#41a1dd",
        }
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
      }
    },
  },
  variants: {},
  plugins: [],
}
