
<html>
 <body>
  <h1 id="inclusion-handling">
   Inclusion handling
  </h1>
  <h2 id="purpose">
   Purpose
  </h2>
  <p>
   The purpose of this study is to show the influence of inclusion inside of substructures on the convergence properies of the FETI algorithms
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
   <a href="../../thesis/fig/tikz/study_inclusion.pdf">
    Figure 6.24
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_inclusion_residual.pdf">
    Figure 6.25
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_inclusion_adaptive.pdf">
    Figure 6.26
   </a>
   <br/>
   <a href="../../thesis/fig/tikz/study_inclusion_adaptive_dirich.pdf">
    Figure 6.27
   </a>
  </p>
  <h2 id="structure">
   Structure
  </h2>
  <p>
   The studies cover all introduced solver types, 2 different geometric inclusion configurations and 3 different stiffness ratios.
   <br/>
   The problems are solved for both for Dirichlet and lumped preconditiones
  </p>
  <ul>
   <li>
    Stiffness ratios:
    <ul>
     <li>
      0.001
     </li>
     <li>
      1
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
  <h3 id="runm-link">
   Run.m
   <a href="Run.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Performs calculations for all configurations with a laumped preconditioner.
  </p>
  <h3 id="run_dirichletm-link">
   Run_dirichlet.m
   <a href="Run_dirichlet.m">
    <em>
     link
    </em>
   </a>
  </h3>
  <p>
   Performs calculations for all configurations with a Dirichlet preconditioner.
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