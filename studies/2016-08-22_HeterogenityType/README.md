
<html>
 <body>
  <h1 id="heterogeneity-studies">
   Heterogeneity studies
  </h1>
  <h2 id="purpose">
   Purpose
  </h2>
  <p>
   The purpose of this studies is to show the influence of herterogeneities on the convergence properties
  </p>
  <h2 id="related-figures">
   Related figures
  </h2>
  <p>
   The following figures in the
   <a href="../../thesis/thesis.pdf">
    thesis
   </a>
   have been created with the data produced by this simulations:
  </p>
  <p>
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes.pdf">
    Figure 6.7
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes_residual.pdf">
    Figure 6.8
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes_adaptive.pdf">
    Figure 6.9
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes.pdf">
    Figure 6.10
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes_residual.pdf">
    Figure 6.11
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes_adaptive.pdf">
    Figure 6.12
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard.pdf">
    Figure 6.13
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard_residual.pdf">
    Figure 6.14
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard_adaptive.pdf">
    Figure 6.15
   </a>
  </p>
  <h2 id="structure">
   Structure
  </h2>
  <p>
   For every herterogenity type the following paramteres are varried:
  </p>
  <ul>
   <li>
    Heterogenity ratio
    <ul>
     <li>
      1
     </li>
     <li>
      10
     </li>
     <li>
      100
     </li>
     <li>
      1000
     </li>
    </ul>
   </li>
   <li>
    Solver type
    <ul>
     <li>
      FETI-1
     </li>
     <li>
      FETI-2(Geneo)
     </li>
     <li>
      FETI-S
     </li>
     <li>
      FETI-AS
     </li>
     <li>
      FETI-FAS
     </li>
    </ul>
   </li>
  </ul>
  <h3 id="run_vstripesm-link">
   Run_vstripes.m
   <a href="Run_vstripes.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Runs the analysises for heterogeneities across the interface. The setup is depicted in Figure 6.5 .
   <br/>
   The results are used for Figures
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes.pdf">
    6.7
   </a>
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes_residual.pdf">
    6.8
   </a>
   and
   <a href="../../thesis/fig/tikz/study_heterogenity_hstripes_adaptive.pdf">
    6.9
   </a>
  </p>
  <h3 id="run_hstripesm-link">
   Run_hstripes.m
   <a href="Run_hstripes.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Runs the analysises for heterogeneities along the interface. The setup is depicted in Figure 6.5 .
   <br/>
   The results are used for Figures
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes.pdf">
    6.10
   </a>
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes_residual.pdf">
    6.11
   </a>
   and
   <a href="../../thesis/fig/tikz/study_heterogenity_vstripes_adaptive.pdf">
    6.12
   </a>
  </p>
  <h3 id="run_cboardm-link">
   Run_cboard.m
   <a href="Run_cboard.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Runs the analysises for combined heterogeneities. The setup is depicted in Figure 6.5 .
   <br/>
   The results are used to create Figures
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard.pdf">
    6.13
   </a>
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard_residual.pdf">
    6.14
   </a>
   and
   <a href="../../thesis/fig/tikz/study_heterogenity_cboard_adaptive.pdf">
    6.15
   </a>
  </p>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.1/highlight.min.js">
  </script>
  <script>
   hljs.initHighlightingOnLoad();
  </script>
  <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript">
  </script>
  <script type="text/javascript">
   MathJax.Hub.Config({"showProcessingMessages" : false,"messageStyle" : "none","tex2jax": { inlineMath: [ [ "$", "$" ] ] }});
  </script>
 </body>
</html>