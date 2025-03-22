-- Two cases for auto scaling
--  More users/queries - Spinup more warehouses, Multi-Clustering
--  Complex Queries - Incearse size of the exsting warehouse


--Auto-scaling: when to start an additional cluster?
    -- Standard (2 to 3 consecutive checks, checks are performed every minute): Spinup more warehouses
    -- Economy (5 to 6 consecutive checks): Incearse size of the exsting warehouse


-- Read scaling policy for more details