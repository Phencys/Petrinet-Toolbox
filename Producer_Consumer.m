clear all
Obj = PN;

%Add places
Obj.Add( 'Place', 'Producer_NonIdle' );
Obj.Add( 'Place', 'Consumer_NonIdle' );
Obj.Add( 'Place', 'Buffer' );

%Add places with initial markings
Obj.Add( 'Place', 'Producer_ReadyToProduce', 'Dot', '1.');
Obj.Add( 'Place', 'Consumer_ReadyToConsume', 'Dot', '1.' );

%Add transitions
Obj.Add( 'Transition', 'Produce' );
Obj.Add( 'Transition', 'Producer_ToIdle' );
Obj.Add( 'Transition', 'Consume' );
Obj.Add( 'Transition', 'Consumer_ToIdle' );

%Add arcs
%Produce
Obj.Add( 'Arc', 'Producer_ReadyToProduce->Produce', '1.' );
Obj.Add( 'Arc', 'Produce->Producer_NonIdle', '1.' );
Obj.Add( 'Arc', 'Produce->Buffer', '1.' );
%Producer_ToIdle
Obj.Add( 'Arc', 'Producer_ToIdle->Producer_ReadyToProduce', '1.' );
Obj.Add( 'Arc', 'Producer_NonIdle->Producer_ToIdle', '1.' );
%Consume
Obj.Add( 'Arc', 'Buffer->Consume', '1.' );
Obj.Add( 'Arc', 'Consume->Consumer_ReadyToConsume', '1.' );
Obj.Add( 'Arc', 'Consumer_NonIdle->Consume', '1.' );
%Consumer_ToIdle
Obj.Add( 'Arc', 'Consumer_ReadyToConsume->Consumer_ToIdle', '1.' );
Obj.Add( 'Arc', 'Consumer_ToIdle->Consumer_NonIdle', '1.' );
