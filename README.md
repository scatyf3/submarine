# submarine
This is an demo that uses Bayes’ theorem to salvage a wrecked submarine.

```
                               /
                               \
                               |
                             __|__
                            |     \
                                    /
     ____  _________________|___ ___\__________/ ____
    <   /                                            \____________  |
     /                                                            \ (_)
~~~~~~     O       O       O                                       >=)~~~~~~~
       \_______/ ____________\  /_________________________________/ (_)

```


# usage

Firstly, you need to install python

Second, use this command to start simulation

```sh
pip install -r requirements.txt
python runner.py
```

# project explain

```
.
├── BayesAI.py //These codes record how our simple artificial intelligence makes decisions through Bayes' theorem
├── Loader.py // Load data from csv, which is generate by model1 simluation in matlab
├── README.md // project description
├── data // pip package requirement
│   └── result_iter-pi:4-3600s.csv
├── model1
│   ├── gen_random_alpha.m
│   ├── gen_random_v.m
│   ├── move_equations.m
│   └── sim_movement.m
├── requirements.txt
└── runner.py // render result


```
