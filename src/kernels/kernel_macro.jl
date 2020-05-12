"""
    @kernel [variance *] kernel
    @kernel [variance *] kernel l=Real/Vector
    @kernel [variance *] kernel t=transform

The `@kernel` macro is an helping alias to the [`transform`](@ref) function.
The first argument should be a kernel multiplied (or not) by a scalar (variance of the kernel).
The second argument (optional) can be a keyword :
 - `l=ρ` where `ρ` is a positive scalar or a vector of scalar
 - `t=transform` where `transform` is a [`Transform`](@ref) object
One can also directly use a `Transform` object without a keyword.

# Examples
```jldoctest
julia> k = @kernel SqExponentialKernel() l=3.0
Squared Exponential Kernel
    - Scale Transform (s = 3.0)

julia> k == transform(SqExponentialKernel(), ScaleTransform(3.0))
true

julia> k = @kernel (MaternKernel(ν=3.0) + LinearKernel()) t=LinearTransform(rand(4,3))
Sum of 2 kernels:
    - (w = 1.0) Matern Kernel (ν = 3.0)
    - (w = 1.0) Linear Kernel (c = 0.0)
    - Linear transform (size(A) = (4, 3))

julia> k == transform(KernelSum(MaternKernel(ν=3.0), LinearKernel()), LinearTransform(rand(4,3)))
true

julia> k = @kernel 4.0*ExponentiatedKernel() l=3.0
Exponentiated Kernel
    - Scale Transform (s = 3.0)
    - σ² = 4.0
julia> k == ScaleTransform(transform(ExponentiatedKernel(), ScaleTransform(3.0)), 4.0)
true
```
"""
macro kernel(expr::Expr, arg = nothing)
    @capture(expr, ((scale_ * k_) | (k_)))
    if arg === nothing
        t = nothing
    else
        if @capture(arg, ((l = val_) | (t = val_)))
            t = val
        else
            return :(error("The additional argument of `@kernel` is incorrect"))
        end
    end
    if scale === nothing
        return :(transform($(esc(k)), $(esc(t))))
    else
        return :($(esc(scale)) * transform($(esc(k)), $(esc(t))))
    end
end
