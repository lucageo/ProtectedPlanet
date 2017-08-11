<template>
  <div class="v-sticky-nav">
    <div class="v-sticky-nav__wrapper flex-row" :class="{ 'v-sticky-nav__wrapper--stuck' : this.isNavSticky, 'v-sticky-nav__wrapper--unstick' : !this.isNavSticky }">

      <div 
        @click="toggleMenu" 
        class="v-sticky-nav__burger" 
        :class="{ 'v-sticky-nav__burger--open' : isMenuOpen }">

        <span class="v-sticky-nav__burger-icon"></span>
      </div>

      <ul class="v-sticky-nav__menu" :class="{ 'v-sticky-nav__menu--open' : this.isMenuOpen }">
        <li v-for="link in json" @click="closeMenu" class="v-sticky-nav__menu-item">
          <a class="v-sticky-nav__link" @click.prevent="scroll(link.id)">{{ link.name }}</a>
        </li>
      </ul>

    </div>
  </div>  
</template>

<script>
  module.exports = {
    name: 'sticky-nav',

    props: {
      json: Array
    },

    data: function() {
      return {
        config: {
          breakpoints : {
            medium: 763 //this MUST match the breakpoint set in the responsive.scss file
          }
        },
        navY: 0,
        navHeight: 0,
        isMenuOpen: false,
        isNavSticky: false
      }
    },

    mounted: function() {
      var nav = $('.v-sticky-nav')

      this.navHeight = nav.height()
      this.navY = nav.offset().top

      this.updateNav()
      this.monitorResize()
    },

    methods: {
      toggleMenu: function () {
        this.isMenuOpen = !this.isMenuOpen
      },

      closeMenu: function () {
        if(this.isMenuOpen){
          this.isMenuOpen = false
        }
      },

      updateNav: function () {
        var self = this

        setInterval(function () {
          scrollY = window.pageYOffset
          
          if(scrollY > self.navY + self.navHeight){
            self.isNavSticky = true
          } else {
            self.isNavSticky = false
          }
        }, 100)
      },

      scroll: function (sectionId) {
        sectionY = $('#' + sectionId).offset().top - this.navHeight + 1

        $('html, body').animate({
          scrollTop: sectionY
        }, 400, function(){
          window.location.hash = sectionId
        })
      },

      monitorResize: function () {
        var self = this

        $(window).on('resize', function(){
          width = $(window).width()

          if(width > self.config.breakpoints.medium){ self.isMenuOpen = false }
        })
      }
    }
  }
</script>