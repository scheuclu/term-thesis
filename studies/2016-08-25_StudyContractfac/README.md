
<html>
 <body>
  <h1 id="contraction-factor-study">
   Contraction factor study
  </h1>
  <h2 id="purpose">
   Purpose
  </h2>
  <p>
   The purpose ot this study is the analysis of the inluence of the contraction factor in the FETI-AS algorithm on number ot iterattion is uses.
  </p>
  <h2 id="related-figures-in-thesis">
   Related figures in thesis
  </h2>
  <p>
   The following images in the
   <a href="../../thesis/thesis.pdf">
    thesis
   </a>
   have been created with the data produced by the simulations here:
  </p>
  <p>
   <a href="../../thesis/fig/tikz/study_contractfac_setup1.pdf">
    Figure 5.6
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_contractfac_setup2.pdf">
    Figure 5.7
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_contractfac_steps_visualization.pdf">
    Figure 5.9
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_contractfac_ts-development.pdf">
    Figure 5.13
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_contractfac_fetifas.pdf">
    Figure 5.14
   </a>
  </p>
  <h2 id="structure">
   Structure
  </h2>
  <p>
   There are several runfiles int this folder:
  </p>
  <h3 id="run_contractfacm-link">
   Run_contractfac.m
   <a href="Run_contractfac.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   This file runs the contraction factor analysis for 2 different geometrical configurations (setup1 and setup2) as well as 8 different values for the contraction factor. The results are used to create Figures
   <a href="/home/lukas/Downloads/Scheucher/SA_Thesis/thesis/fig/tikz/study_contractfac_setup1.pdf">
    5.6
   </a>
   and
   <br/>
   <a href="../../thesis/fig/tikz/study_contractfac_setup2.pdf">
    5.7
   </a>
   .
   <br/>
   For every setup fema_pre.m is called only once, since the result of the preprocessing does not change with an alterning contraction factor.
  </p>
  <h3 id="run_contractfac_detailm-link">
   Run_contractfac_detail.m
   <a href="Run_contractfac_detail.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Runs the contraction factor analysis on the same setups as before, only this time is is restricted to a very small range of contraction factors. The results have not been used to create any image in the final thesis.
  </p>
  <h3 id="run_fasm-link">
   Run_fas.m
   <a href="Run_fas.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Used to analyze the different FETI-FAS schemes proposed. The results are used to create Figure
   <a href="../../thesis/fig/tikz/study_contractfac_fetifas.pdf">
    5.14
   </a>
   .
  </p>
  <h3 id="run_ts_fetism-link">
   Run_ts_fetis.m
   <a href="Run_ts_fetis.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   The file rus several simulations of FETI-S to analze how the ts paramters develops. The results are used to create Figures
   <a href="../../thesis/fig/tikz/study_contractfac_steps_visualization.pdf">
    5.9
   </a>
   and
   <a href="../../thesis/fig/tikz/study_contractfac_ts-development.pdf">
    5.13
   </a>
   .
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