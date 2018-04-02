import * as d3 from 'd3';

export let getPath = (data, dim) => { 
  const [w, h] = dim; 
  const x = d3.scaleLinear()
    .domain([0, data.length])
    .range([0, w]);
  
  const y = d3.scaleLinear()
    .domain([0, d3.max(data)])
    .range([0, h]);
    
  const line = d3.line()
    .x((d, i) =>  x(i))
    .y((d, i) => y(d))
    .curve(d3.curveBasis);
  
  return line(data);
}
