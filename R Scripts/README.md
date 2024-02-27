## Basic repo setup for final project

My final product will look at data on college drop out numbers to try to predict the factors that make a student more prone to dropping out.

## Folders:

-   `data`: folder with original data and cleaned data. See more in the readme in the folder.
-   `memos`: includes the r scripts, qmds, and html files for my progress memos. See more in readme in the folder.
-   `results`: contains all results. See more in readme in the folder.

## Files:
-   `01_initial_setup`: split dataset into testing and training, split folds, saved everything out
-   `02_recipes`: currently defined a kitchen sink recipe with variations for naive bayes, parametric and non-parametric models
-   `03_fit_multinomial`: fitted multinomial model
-   `03_fit_naive_bayes`: fitted naive bayes model
-   `03_tuned_bt`: tuned boosted tree
-   `03_tuned_elastic_net`: tuned elastic net
-   `03_tuned_knn`: tuned K-nearest neighbor
-   `03_tuned_rf`: tuned random forest
-   `04_baseline_mod_results`: comparison of baseline model (naive bayes) with multinomial model
-   `04_mod_results_analysis`: analysis of all model results