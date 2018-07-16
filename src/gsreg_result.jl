type GSRegResult
    depvar::Symbol         # Dependant variable names
    expvars::Array{Symbol} # Explanatory variables names
    data                   # Actual data
    intercept              # Include or not the constant
    outsample              # Amount of rows (observations) that will be use as outsample
    samesample             # Each combination uses the same sample
    criteria               # Ordering criteria (r2adj, caic, aic, bic, cp, rmsein, rmseout)
    ttest                  # Calculate or not the ttest
    vectoroperation        # Calculate using vector operations
    modelavg               # Generate model averaging report
    residualtest           # Estimate white noise residual tests
    keepwnoise             # Filter results based on white noise residual tests
    time                   # Pre-order data by Symbol
    datanames              # Original CSV header names
    datatype               # Float32 or Float64 precision
    nobs                   # Number of observations
    header                 # Header Symbols and positions
    orderresults           # Order or not the results
    results                # Results array
    bestresult             # Best result
    average                # Model averaging array data

    function GSRegResult(
            depvar::Symbol,
            expvars::Array{Symbol},
            data,
            intercept::Bool,
            outsample::Int,
            samesample::Bool,
            criteria,
            ttest,
            vectoroperation,
            modelavg,
            residualtest,
            keepwnoise,
            time,
            datanames,
            datatype,
            orderresults
        )
        if :r2adj ∉ criteria
            push!(criteria, :r2adj)
        end

        nobs = size(data, 1)

        if intercept
            data = Array{datatype}(hcat(data, ones(nobs)))
            push!(expvars, :_cons)
            push!(datanames, :_cons)
        end

        header = get_result_header(expvars, intercept, ttest, residualtest, time, criteria)
        new(depvar, expvars, data, intercept, outsample, samesample, criteria, ttest, vectoroperation, modelavg, residualtest, keepwnoise, time, datanames, datatype, nobs, header, orderresults)
    end
end