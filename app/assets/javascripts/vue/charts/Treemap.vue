<template>
  <div class="d3-treemap" :style="{ paddingTop: paddingTop }"></div>
</template>

<script>
  module.exports = {
    name: 'treemap',

    props: {
      interactive: Boolean,
      json: { required: true }
    },

    data: function() {
      return {
        config: {
          width: 700,
          height: 500
        },
        orderedData: 0,
      }
    },

    mounted: function() {
      this.renderChart()

      //trigger mouse enter on the first cell so that the info panel is populated
      var firstCountry = '#' + (this.orderedData.children[0].data.id).replace(/\s|\./g, '-')
      d3.select(firstCountry).dispatch('mouseenter')
    },

    methods: {
      renderChart: function(){
        var svg = this.createSVG()

        //data
        var treemap = d3.treemap()
          .tile(d3.treemapBinary)
          .size([this.config.width, this.config.height])
          .round(true)
          .paddingInner(1)

        var data = d3.hierarchy(this.json)
          .eachBefore(function(d) { d.data.id = (d.parent ? d.parent.data.id + "." : "") + d.data.name})
          .sum(function (d) { return d.national + d.overseas })
          .sort(function(a, b) { return b.height - a.height || b.value - a.value })

        this.orderedData = data

        var nodes = treemap(data)

        //color scheme
        var totalItems = nodes.count().value
        var color = d3.scaleLinear().range(['#729099', '#C2E5E9']).domain([0, totalItems - 1])

        //build chart
        var cell = svg.selectAll('g')
          .data(nodes.leaves())
          .enter().append('g')
          .attr('id', function(d) { return (d.data.id).replace(/\s|\./g, '-') })
          .attr('class', 'd3-treemap-cell v-interactive-treemap__cell')
          .attr('transform', function(d) { return 'translate(' + d.x0 + ',' + d.y0 + ')' })

        cell.append('rect')
            .attr('width', function(d) { return d.x1 - d.x0 })
            .attr('height', function(d) { return d.y1 - d.y0 })
            .attr('fill', function(d, i) { return color(i) })

        cell.append('text')
          .attr('transform', function(d) {
              x = (d.x1 - d.x0)/2
              y = (d.y1 - d.y0)/2 + 6
              return 'translate(' + x + ',' + y + ')'
            }
          )
          .attr('text-anchor', 'middle')
          .selectAll('tspan')
          .data(function(d) { return d.data.iso.split(/(?=[A-Z][^A-Z])/g) })
          .enter().append('tspan')
          .style('fill', 'white')
          .style('font-family', 'sans-serif')
          .text(function(d) { return d })

        if(this.interactive){
          var self = this
          cell.on('mouseenter touchstart', function (d) { self.mouseenter(d.data) })
        }
      },

      createSVG: function (){
        var svg = d3.select('.d3-treemap')
          .append('svg')
          .attr('class', 'u-block d3-treemap__svg')
          .attr('xmlns', 'http://www.w3.org/1999/xhtml')
          .attr('viewBox', '0 0 ' + this.config.width + ' ' + this.config.height)
          .attr('viewport', this.config.width + 'x' + this.config.height)
          .attr('preserveAspectRatio', 'xMidYMid')
          .attr('width', '100%')
          .attr('height', '100%')

        return svg
      },

      mouseenter: function (data) {
        var activeClass = 'v-interactive-treemap__cell-active'

        $('.d3-treemap-cell').removeClass(activeClass)
        $('#' + (data.id).replace(/\s|\./g, '-')).addClass(activeClass)

        var data = {
          country: data.name,
          iso: data.iso,
          totalMarineArea: data.totalMarineArea,
          totalOverseasTerritories: data.totalOverseasTerritories,
          overseasTerritoriesURL: data.overseasTerritoriesURL,
          national: data.national,
          nationalPercentage: data.nationalPercentage,
          overseas: data.overseas,
          overseasPercentage: data.overseasPercentage
        }

        this.$emit('mouseenter', data)
      }
    },

    computed: {
      paddingTop: function () {
        return (this.config.height / this.config.width) * 100 + '%'
      }
    }
  }
</script>
