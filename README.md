# Item-Level Network Analysis of the Statistics Anxiety Rating Scale (STARS)

Data, code and outputs for the final report of **PL4246** Semester 1, AY2026/2027, Nitika Magdalene Vijay Amirthraj.

The project estimates a partial-correlation network of the 51 STARS items (n = 182), then examines its macro-level structure, its community structure compared with the six established STARS subscales, and item-level node strength and bridging.



## Repository structure
```text
.
├── README.md
├── Data/
│   └── stars-data_182.csv         # Raw item-level data (51 items, n = 182)
├── Information/
│   ├── dataset4.pdf               # Dataset documentation
│   └── stars-items.md             # Wording of the 51 STARS items
├── Object/
│   └── stars_network.RData        # Saved igraph network object
├── Output/
│   ├── bridging.csv               # Bridging scores, ranked
│   ├── louvain_vs_subscales.csv   # Item-level Louvain community and subscale membership
│   ├── node_strength.csv          # Weighted node strength, ranked
│   ├── table1_crosstab.csv        # Table 1: Louvain communities x STARS subscales
│   ├── figure1_network.png        # Figure 1: network coloured by Louvain community
│   └── sessionInfo.txt            # R and package versions used
└── Scripts/
    ├── dataset4.R                 # Helper data set for network 
    └── Star Network Analysis.R    # Full analysis script (all steps below)
```

## Data

`Data/stars-data_182.csv` contains responses from 182 participants to the 51-item STARS. Documentation for the dataset is in `Information/dataset4.pdf`, and the wording of each item is in `Information/stars-items.md`. Source: [dataset source, as given by the course]. [State whether the data can be shared, and any permissions or licence.]

Items are assigned to the six STARS subscales in the script (`stars_subscales`): Test and Class Anxiety, Interpretation Anxiety, Fear of Asking for Help, Worth of Statistics, Computational Self-Concept, and Fear of Statistics Teachers.

How to reproduce the analysis

1. Clone or download this repository and open the project folder as the R working directory.
2. Install the required packages (see below).
3. Run `Scripts/Star Network Analysis.R` from top to bottom. [Say whether `Scripts/dataset4.R` needs to be run first, and when.] The script runs these steps in order:
   1. **Network estimation:** a partial-correlation network of the 51 items using `bootnet::estimateNetwork()` (`default = "pcor"`, `threshold = "sig"`, no regularisation). Edge weights are converted to absolute values and the network is stored as an undirected weighted `igraph` object (`stars_network`).
   2. **Macro-level metrics:** average degree, average shortest path length, global clustering coefficient, density, diameter, degree assortativity, and connected components. The small-world index is computed against 100 Erdős–Rényi random graphs with the same number of nodes and edges.
   3. **Community detection:** Louvain algorithm on the weighted network, with modularity.
   4. **Comparison with STARS subscales:** cross-tabulation of Louvain communities against the six subscales, and modularity of the original subscale assignment.
   5. **Node strength:** weighted strength for each item.
   6. **Bridging:** `influenceR::bridging()`, with the five highest-scoring items identified.
4. Outputs are written to `Output/` and the network object to `Object/`.

## Random seeds

Results that depend on random processes use fixed seeds: `set.seed(2)` before generating the random graphs for the small-world index, and `set.seed(1)` before Louvain community detection and before the network layout used in the figure.

## Software
Full session details are in `Output/sessionInfo.txt`.

## Notes

- Item labels: items 1 to 5 appear as `it_1` to `it_5` in the outputs and items 6 to 51 as `i_6` to `i_51`. [Explain how these relate to the column names in the raw data, if they differ.]
- `influenceR::bridging()` is computed on the whole network and does not use the Louvain community assignments, so a high bridging score does not by itself mean an item links different communities. This is discussed in the report.
- Edge weights are absolute partial correlations, so the direction of associations is not retained.

## Report

The accompanying research report (PDF) was submitted separately for PL4246. 
## Contact

Nitika Magdalene Vijay Amirthraj, nitikavijay@u.nus.edu
