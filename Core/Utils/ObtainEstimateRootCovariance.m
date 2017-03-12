function [ RootCovariance, InvRootCovariance, LogDetCovariance ] = ObtainEstimateRootCovariance( Covariance, StdDevThreshold )

    assert( all( isfinite( Covariance(:) ) ), 'ESTNLSS:ObtainEstimateRootCovariance:NonFiniteInputCovariance', 'ObtainEstimateRootCovariance was called on a non-finite input covariance.' );

    Covariance = full( 0.5 * ( Covariance + Covariance' ) );
    [ U, D ] = schur( Covariance, 'complex' );
    diagD = diag( D );
    RootD = sqrt( max( 0, real( diagD ) ) );
    IDv = RootD > StdDevThreshold;
    Usub = real( U( :, IDv ) );
    RootCovariance = Usub * diag( RootD( IDv ) );
    
    assert( all( isfinite( RootCovariance(:) ) ), 'ESTNLSS:ObtainEstimateRootCovariance:NonFiniteOutputRootCovariance', 'ObtainEstimateRootCovariance returned a non-finite output root covariance.' );

    if nargout > 1

        InvRootCovariance = diag( 1 ./ RootD( IDv ) ) * Usub';
        
        assert( all( isfinite( InvRootCovariance(:) ) ), 'ESTNLSS:ObtainEstimateRootCovariance:NonFiniteOutputInvRootCovariance', 'ObtainEstimateRootCovariance returned a non-finite output inverse root covariance.' );
        
        if nargout > 2

            LogDetCovariance = sum( log( RootD ) );

            assert( isfinite( LogDetCovariance ), 'ESTNLSS:ObtainEstimateRootCovariance:NonFiniteLogDetCovariance', 'ObtainEstimateRootCovariance returned a non-finite output log det covariance.' );
        
        end
        
    end
    % InvRootCovariance * RootCovariance = diag( 1 ./ RootD( IDv ) ) * Usub' * Usub * diag( RootD( IDv ) ) = eye
    % RootCovariance * InvRootCovariance = Usub * diag( RootD( IDv ) ) * diag( 1 ./ RootD( IDv ) ) * Usub' = Usub * Usub'
end
