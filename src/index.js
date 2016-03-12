import d3Scale from 'd3-scale';
import d3Shape from 'd3-shape';
import d3Array from 'd3-array';

const data = [23, 8, 4, 19, 5, 7, 10];
const dim = [500, 500];

export let getPath = () => {  
  const x = d3Scale.scaleLinear()
    .domain([0, data.length])
    .range([0, dim[0]]);
  
  const y = d3Scale.scaleLinear()
    .domain([0, d3Array.max(data)])
    .range([0, dim[1]]);
    
  const line = d3Shape.line()
    .x((d, i) =>  x(i))
    .y((d, i) => y(d))
    .curve(d3Shape.curveBasis);
  
  return line(data);
}
