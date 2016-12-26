<html>
 <body>
  <h1 id="incompressibility-study">
   Incompressibility study
  </h1>
  <h2 id="purpose">
   Purpose
  </h2>
  <p>
   The purpose of this studies is to show the influence of partitioning schemes on the convergence properties of FETI.
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
   <a href="../../thesis/fig/tikz/study_incompressibility.pdf">
    Figure 6.21
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_incompressibility_adaptive.pdf">
    Figure 6.22
   </a>
  </p>
  <h2 id="structure">
   Structure
  </h2>
  <p>
   The studies cover all introduced solver types, as well as 4 different values for the Poisson’s ratio.
   <br/>
   The problems are solved for both for plane-stress and plane-strain formulation.
  </p>
  <ul>
   <li>
    Poisson’s ratio
    <ul>
     <li>
      0.49
     </li>
     <li>
      0.499
     </li>
     <li>
      0.4999
     </li>
     <li>
      0.49999
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
  <p>
   All calculations are done via
   <a href="Run.m">
    Run.m
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