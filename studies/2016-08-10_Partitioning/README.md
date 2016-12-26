
<html>
 <body>
  <h1 id="partitioning-study">
   Partitioning study
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
   <a href="../../thesis/fig/tikz/study_partitioning_numiter.pdf">
    Figure 6.17
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_partitioning_residual.pdf">
    Figure 6.18
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_partitioning_numsdir.pdf">
    Figure 6.19
   </a>
  </p>
  <h2 id="structure">
   Structure
  </h2>
  <p>
   The studies cover all introduced solver types, as wel as 4 different partitioning schemes(see Figure 6.16).
  </p>
  <ul>
   <li>
    Partitioning schemes
    <ul>
     <li>
      Regular, uniform partioning
     </li>
     <li>
      Automatic uniform graph partitioning
     </li>
     <li>
      Stripe-like partitioning parallel to the force boundary-conditions
     </li>
     <li>
      Stripe-like partitioning orthogonal to the force boundary-conditions
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
