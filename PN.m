classdef PN < handle
  
%% Normal Private Properties
  properties( SetAccess = private )
    %>The initial state of the net.
    %> - The initial state of the net is stored here, as a [Colors x Places] matrix.
    %> - An entry (i,j) in this matrix denotes the amount of tokens of color i that place j initially contains.
    %> \f[\bordermatrix{ & p_1  & p_2  & \dots & p_n \cr c_1 & [~~] & [~~] & & [~~] \cr c_2 & [~~] & [~~] & & [~~] \cr \vdots & & & & \cr c_m & [~~] & [~~] & & [~~] \cr }\f]
    Initial;
    %>The current state of the net.
    %> - The current state of the net is stored here, as a [Colors x Places] matrix.
    %> - An entry (i,j) in this matrix denotes the amount of tokens of color i that place j currently contains.
    %> - This matrix will be overwritten after calling PN.Update(), which happens in all functions that alter the net
    %> \f[\bordermatrix{ & p_1  & p_2  & \dots & p_n \cr c_1 & [~~] & [~~] & & [~~] \cr c_2 & [~~] & [~~] & & [~~] \cr \vdots & & & & \cr c_m & [~~] & [~~] & & [~~] \cr }\f]
    Current;
    %>An array of all Places that are used in the net.
    %> - This array contains all the identifiers of places that are part of the net, e.g. all \f$ p \in P \f$.
    %> - The array is used for indexing on all the matrices that deal with Places.
    %> - Removal of an entity here does not automatically trigger other removals. Use PN.Remove( Identifier ) instead.
    %> \f[\bordermatrix{ & \cr & p_1 \cr & p_2 \cr & \vdots \cr & p_n }\f]
    Places;
    %>An array of all Transitions that are used in the net.
    %> - This array contains all the identifiers of transitions that are part of the net, e.g. all \f$ t \in T \f$.
    %> - The array is used for indexing on all the matrices that deal with Transitions.
    %> - Removal of an entity here does not automatically trigger other removals. Use PN.Remove( Identifier ) instead.
    %> \f[\bordermatrix{ & \cr & t_1 \cr & t_2 \cr & \vdots \cr & t_n }\f]
    Transitions;
    %>A matrix of all Colors that are used in the net.
    %> - This matrix contains all the colors that are part of the net, e.g. all \f$ c \in C_n \f$ for all color sets \f$ C_n \f$
    %> - The matrix is used for indexing on all other matrices that deal with Colors.
    %> - Removal of an entity here does not automatically trigger other removals. Use PN.Remove( Identifier ) instead.
    %> \f[\bordermatrix{ & \mathrm{Color} & \mathrm{ColorSet} \cr & c_1 & C_1 \cr & c_2 & C_1 \cr & \vdots & \vdots \cr & c_m & C_n }\f]
    Colors;
    %>A matrix of all Color Sets that are used in the net.
    %> - This array contains all the identifiers of ColorSets that are part of the net, e.g. all \f$ C_n \in C\f$
    %> - The matrix is used for indexing on all other matrices that deal with ColorSets.
    %> - Removal of an entity here does not automatically trigger other removals. Use PN.Remove( Identifier ) instead.
    %> \f[\bordermatrix{ & \cr & C_1 \cr & C_2 \cr & \vdots \cr & C_n }\f]
    ColorSets;
    %>A matrix of all Variables that are used in the net
    %> - This matrix contains all the Variables that are part of the net, e.g. all \f$ v \in V \f$
    %> - The matrix is used for indexing on all other matrices that deal with Variables.
    %> - Removal of an entity here does not automatically trigger other removals. Use PN.Remove( Identifier ) instead.
    %> \f[\bordermatrix{ & \mathrm{Variable} & \mathrm{ColorSet} \cr & v_1 & C_2 \cr & v_2 & C_1 \cr & \vdots & \vdots \cr & v_m & C_n }\f]
    Variables;
    %>A matrix containing the "Effect" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Effect values of all possible range arcs.
    %> - Entries in this matrix are arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr c_1 & [~~] \cr c_2 & [~~] \cr \vdots & \cr c_n & [~~] }\f]
    Arcs_Effect;
    %>A matrix containing the "Lower Bound" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Lower Bound values of all possible range arcs.
    %> - Entries in this matrix are **strictly positive** arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr c_1 & [~~] \cr c_2 & [~~] \cr \vdots & \cr c_n & [~~] }\f]
    Arcs_Lower;
    %>A matrix containing the "Upper Bound" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Upper Bound values of all possible range arcs.
    %> - Entries in this matrix are **strictly positive** arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr c_1 & [~~] \cr c_2 & [~~] \cr \vdots & \cr c_n & [~~] }\f]
    Arcs_Upper;
    %>A matrix containing the variable-determined "Effect" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Effect values of variables on range arcs.
    %> - Entries in this matrix are arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr v_1 & [~~] \cr v_2 & [~~] \cr \vdots & \cr v_n & [~~] }\f]
    %> - Note that variables need to be bound to a specific color to obtain the final effect.
    Arcs_Effect_Variables;
    %>A matrix containing the variable-determined "Lower Bound" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Lower Bound values of variables on range arcs.
    %> - Entries in this matrix are **strictly positive** arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr v_1 & [~~] \cr v_2 & [~~] \cr \vdots & \cr v_n & [~~] }\f]
    %> - Note that variables need to be bound to a specific color to obtain the final effect.f the arc.
    Arcs_Lower_Variables;
    %>A matrix containing the variable-determined "Upper Bound" values of all range arcs.
    %> - A [Places x Transitions] matrix that contains the Upper Bound values of variables on range arcs.
    %> - Entries in this matrix are **strictly positive** arrays of the form:
    %> \f[\bordermatrix{ & \mathrm{Effect} \cr v_1 & [~~] \cr v_2 & [~~] \cr \vdots & \cr v_n & [~~] }\f]
    %> - Note that variables need to be bound to a specific color to obtain the final effect.f the arc.
    Arcs_Upper_Variables;
    %>A handle to an image of the net.
    %> - If an image is shown, this is the handle of the image.
    Handle;
  end
  
%% Debug Private Properties
  properties( SetAccess = private )
    %>[DEBUG] Indicates whether this net should generate debug-level info.
    %> - Used for debugging purposes
    %> - Property is set by using 'DEBUG' as the second parameter in the constructor
    %> - If not 0, the net will generate debug output.
    DebugObject = 0;
    %>A matrix used as Icon Data for messages that are generated.
    %> - A 50x50 matrix height map, to be used together with color mappings.
    %> - This matrix should NOT be edited, unless you want a different type of icon.
    %> - See matlab 'msgbox()' documentation for pointers on custom icons.
    IconData = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 4 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1;1 1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1 1;1 1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1 1;1 1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1 1;1 1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1 1 1 1;1 1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1 1;1 1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1;1 1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1 1;1 1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1;1 1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1 1;1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1;1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1;1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1;1 1 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1;1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 1 1;1 1 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 1 1;1 1 2 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 2 1 1;1 1 1 2 2 2 2 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 2 2 2 2 2 2 2 1 1;1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1;1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1;1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1;1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    %>A matrix used as Icon Map for messages of the type 'Debug'
    %> - A 4x3 'RGB' matrix that determines the colors to be used for Debug messages.
    %> - Values range between 0 and 1
    %> - Row meanings:
    %>   - 1: Color of the icon background.
    %>   - 2: Color of the icon border.
    %>   - 3: Color of the exclamation mark.
    %>   - 4: Color of the internal background.
    DebugColors = [0.7 0.7 0.7;0 0 0;0 0 0;0 1 0];
    %>A matrix used as Icon Map for messages of the type 'Warning'
    %> - A 4x3 'RGB' matrix that determines the colors to be used for Warning messages.
    %> - Values range between 0 and 1
    %> - Row meanings:
    %>   - 1: Color of the icon background.
    %>   - 2: Color of the icon border.
    %>   - 3: Color of the exclamation mark.
    %>   - 4: Color of the internal background.
    WarningColors = [0.7 0.7 0.7;0 0 0;0 0 0;1 1 0];
    %>A matrix used as Icon Map for messages of the type 'Error'
    %> - A 4x3 'RGB' matrix that determines the colors to be used for Error messages.
    %> - Values range between 0 and 1
    %> - Row meanings:
    %>   - 1: Color of the icon background.
    %>   - 2: Color of the icon border.
    %>   - 3: Color of the exclamation mark.
    %>   - 4: Color of the internal background.
    ErrorColors = [0.7 0.7 0.7;0 0 0;0 0 0;1 0 0];
    %> The list of all (Debug) messages that are generated up till now.
    %> - Holds all messages that still need to be shown.
    %> - This list is iterated over backwards by ParseAllMessages to generate all popup messages.
    %> - Messages are added using the CreateMessage() function.
    AllMessages = {};
  end
  
%% Normal Private Methods
  methods( Access = private )
    %% InitializeEmptyNet
    %>Initializes an empty net.
    %> - Creates a new net with default (empty) values.
    %>
    %>\param Object The object to be initialized.
    %>
    %>\returns Exception
    %> - The exception that was active upon leaving the function
    %>
    %>\exception E_NONE No exception thrown
    function [Exception] = InitializeEmptyNet( Object )
      Exception = 'E_NONE';
      Object.Places = {};
      Object.Transitions = {};
      Object.Initial = [];
      Object.Current = [];
      Object.Arcs_Lower = {};
      Object.Arcs_Upper = {};
      Object.Arcs_Effect = {};
      Object.Arcs_Lower_Variables = {};
      Object.Arcs_Upper_Variables = {};
      Object.Arcs_Effect_Variables = {};
      Object.ColorSets = {'Dot','.'};
      Object.Colors = {'.','Dot'};
      Object.CreateMessage('Exception Handling 1',{'Function: InitializeEmptyNet';['Exception: ',Exception]},'Debug');
    end
    
    %% IsUnique
    %>Checks uniqueness of a name.
    %> - Searches for the value of Name in the net.
    %> - Checks:
    %>   - Places
    %>   - Transitions
    %>   - Colors
    %>   - Variables
    %>   - ColorSets
    %>
    %>\param Object The Petri-Net to check values for.
    %>\param Name The name to check for existence.
    %>
    %>\return Boolean
    %> - Status after execution.
    %> - True when Name is unique, false when it already exists.
    %>\return Exception
    %> - The exception that was active upon leaving the function.
    %>
    %>\exception E_NONE No exception thrown
    %>\exception E_UNIQUE The name is not unique
    function [Boolean,Exception] = IsUnique( Object, Name )
      Temp = [];
      if ~isempty( Object.Places )
        Temp = [Temp;Object.Places(:,1)];
      end
      if ~isempty( Object.Colors )
        Temp = [Temp;Object.Colors(:,1)];
      end
      if ~isempty( Object.Transitions )
        Temp = [Temp;Object.Transitions(:,1)];
      end
      if ~isempty( Object.Variables )
        Temp = [Temp;Object.Variables(:,1)];
      end
      if ~isempty( Object.ColorSets )
        Temp = [Temp;Object.ColorSets(:,1)];
      end
      Boolean = isempty( find( strcmp( Temp, Name ), 1 ) );
      Exception = 'E_NONE';
      if ~Boolean
        Exception = 'E_UNIQUE';
      end
      Object.CreateMessage('Exception Handling',{'Function: IsUnique';['Exception: ',Exception]},'Debug');
    end
    
    %% GetType
    %>Determines the type of an element
    %> - Given an identifier of an element, determines its type.
    %>
    %>\param Object The Petri-Net to locate the identifier in.
    %>\param Name The identifier of the element.
    %>
    %>\return Type
    %> - The type of the element.
    %>\return Exception
    %> - The exception that was active upon leaving the function.
    %>
    %>\exception E_NONE No exception thrown
    %>\exception E_TYPE Not able to associate a type with the name.
    function [Type,Exception] = GetType( Object, Name )
      Type = '';
      Exception = 'E_NONE';
      if ~isempty( Object.Places ) && ~isempty( find( strcmp( Object.Places(:,1), Name ), 1 ) )
        Type = 'Place';
      end
      if ~isempty( Object.Colors ) && ~isempty( find( strcmp( Object.Colors(:,1), Name ), 1 ) )
          Type = 'Color';
      end
      if ~isempty( Object.Transitions ) && ~isempty( find( strcmp( Object.Transitions(:,1), Name ), 1 ) )
          Type = 'Transition';
      end
      if ~isempty( Object.Variables ) && ~isempty( find( strcmp( Object.Variables(:,1), Name ), 1 ) )
          Type = 'Variable';
      end
      if ~isempty( Object.ColorSets ) && ~isempty( find( strcmp( Object.ColorSets(:,1), Name ), 1 ) )
          Type = 'ColorSet';
      end
      if xor ( ~isempty( strfind( Name, '->' ) ), ~isempty( strfind( Name, '<-' ) ) )
          Type = 'Arc';
      end
      if xor ( ~isempty( strfind( Name, '-o' ) ), ~isempty( strfind( Name, 'o-' ) ) )
          Type = 'Arc';
      end
      if xor ( ~isempty( strfind( Name, '-*' ) ), ~isempty( strfind( Name, '*-' ) ) )
          Type = 'Arc';
      end
      if ~isempty( strfind( Name, '--' ) )
          Type = 'Arc';
      end
      if strmatch( Type, '' )
          Exception = 'E_TYPE';
      end
      Object.CreateMessage('Exception Handling',{'Function: GetType';['Exception: ',Exception]},'Debug');
    end
    
    %% ParseExpressionPart
    %>Handles parsing of expression parts.
    %> - Parses a part of an expression into a (Entity,Value) pair
    %>
    %>\param Object The petri-net to obtain the Entity values from
    %>\param Expression An expression part
    %> - An expression of the form '[Value][Entity]'
    %>   - [Value] denotes an element of \f$\mathcal{R}\f$.
    %>   - [Entity] denotes either a known Color, or a valid Variable
    %>
    %>\return Entity
    %> - A valid net entity, or '' if an exception occured.
    %>\return Value
    %> - A non-negative double, 0 if an exception occured
    %>\return Exception
    %> - The exception that was active upon leaving the function.
    %>
    %>\exception E_NONE No exception thrown 
    %>\exception E_EXPR Something was wrong with the expression
    function [Entity,Value,Exception] = ParseExpressionPart(Object, Expression)
      Entity = '';
      Value = '0';
      Index = 0;
      Exception = 'E_NONE';
      if size( Object.Colors, 1 )
        for i = 1:size( Object.Colors, 1 )
          PossibleIndices = strfind( Expression, Object.Colors{i,1} );
          if ~isempty( PossibleIndices )
            if PossibleIndices(size(PossibleIndices,2)) > Index
              Index = PossibleIndices(size(PossibleIndices,2));
              Entity = Object.Colors{i,1};
            end
          end
        end
      end
      if size( Object.Variables, 1 )
        for i = 1:size(Object.Variables, 1)
          PossibleIndices = strfind( Expression, Object.Variables{i,1} );
          if ~isempty( PossibleIndices )
            if PossibleIndices(size(PossibleIndices,2)) > Index
              Index = PossibleIndices(size(PossibleIndices,2));
              Entity = Object.Variables{i,1};
            end
          end
        end
      end
      if Index == 0
        Object.CreateMessage( 'Exception Handling', {'Function: ParseExpressionPart';'Exception: E_EXPR';'Message: Index == 0'}, 'Error' )
        Exception = 'E_EXPR';
      else
        if ~isnan( str2double( Expression( 1:( length( Expression )-length( Entity ) ) ) ) )
          Value = str2double( Expression( 1:( length( Expression )-length( Entity ) ) ) );
          Object.CreateMessage( 'Exception Handling', {'Function: ParseExpressionPart';'Exception: E_NONE'}, 'Debug' )
        else
          Object.CreateMessage( 'Exception Handling', {'Function: ParseExpressionPart';'Exception: E_EXPR';'Message: Value is NaN'}, 'Error' )
          Exception = 'E_EXPR';
          Entity = '';
        end
      end
    end
    
    %% InColorSet
    %> Determines whether a Color exists in a specific ColorSet.
    %> ### Input Signature
    %>> PN.InColorSet( \<ColorID\>, \<ColorSetID\> )
    %> - Determines whether \<ColorID\> is an element of \<ColorSetID\>.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.InColorSet()
    %> - Boolean stores whether the color is an element of the set or not.
    %> - Exception stores the last active exception.
    function [Boolean,Exception] = InColorSet( Object, Color, ColorSet )
      Exception = 'E_NONE';
      Boolean = 0;
      ColorIdx = strmatch(Color, Object.Colors(:,1) );
      if isempty( ColorIdx )
        Object.CreateMessage('Exception Handling',{'Function: InColorSet','Exception: E_ENTITY'},'Error');
        Exception = 'E_ENTITY';
      else
        ColorSetIdx = strmatch( ColorSet, Object.Colors(ColorIdx,2) );
        if isempty( ColorSetIdx )
          Object.CreateMessage('Exception Handling',{'Function: InColorSet','Exception: E_TYPE'},'Error');
          Exception = 'E_TYPE';
        else
          Boolean = 1;
        end
      end
    end
    
    %% RetrieveIndex
    %> Obtains the index of an Identifier.
    %> ### Input Signatures
    %>> PN.RetrieveIndex( \<IDType\>, \<Identifier\> )
    %> Retrieves the Index of \<Identifier\>, searching through all elements of \<IDType\>.
    %>
    %> ### Output Signature
    %>> [Index,Exception] = PN.RetrieveIndex()
    %> - Index stores the index of the found element, or [] otherwise.
    %> - Exception stores the last active exception.
    function [Index,Exception] = RetrieveIndex( Object, Type, Identifier )
      Index = [];
      Exception = 'E_NONE';
      switch( Type )
        case 'Color'
          if ~isempty( Object.Colors )
            Index = find( strcmp( Identifier, Object.Colors(:,1) ) );
          end
        case 'Place'
          if ~isempty( Object.Places )
            Index = find( strcmp( Identifier, Object.Places(:,1) ) );
          end
        case 'Transition'
          if ~isempty( Object.Transitions )
            Index = find( strcmp( Identifier, Object.Transitions(:,1) ) );
          end
        case 'ColorSet'
          if ~isempty( Object.ColorSets )
            Index = find( strcmp( Identifier, Object.ColorSets(:,1) ) );
          end
        case 'Variable'
          if ~isempty( Object.Variables )
            Index = find( strcmp( Identifier, Object.Variables(:,1) ) );
          end
        otherwise
          Object.CreateMessage('Exception Handling',{'Function: RetrieveIndex';'Exception: E_TYPE'},'Error');
          Exception = 'E_TYPE';
      end
      if isempty( Index )% && ~isempty( strmatch( Exception, 'E_NONE' ) )
        Object.CreateMessage( 'Exception Handling',{'Function: RetrieveIndex';'Exception: E_IDENTIFIER';['Message: ',Identifier, ' not found']},'Error');
        Exception = 'E_IDENTIFIER';
      else
        Index = Index(1);
      end
    end
    
    %% Update
    %> Updates the status of the net.
    %> - Updates the net after addition/removal of places, colors, etc.
    %>
    %> ### Input Signatures
    %>> PN.Update()
    %> ### Output Signature
    %>> PN.Update()
    function Update( Object )
      if size( Object.Places,1) && size(Object.Colors,1)
        if ~isempty( find( size( Object.Initial ) ~= [size(Object.Colors,1) size(Object.Places,1)], 1 ) )
          Object.Initial(size(Object.Colors,1),size(Object.Places,1)) = 0;
        end
      end
      if size( Object.Places,1) && size(Object.Transitions,1)
        if ~isempty( find( size( Object.Arcs_Lower ) ~= [size(Object.Places,1) size(Object.Transitions,1)], 1 ) )
          Object.Arcs_Lower{size(Object.Places,1),size(Object.Transitions,1)} = 0;
          Object.Arcs_Upper{size(Object.Places,1),size(Object.Transitions,1)} = inf;
          Object.Arcs_Effect{size(Object.Places,1),size(Object.Transitions,1)} = 0;
          Object.Arcs_Lower_Variables{size(Object.Places,1),size(Object.Transitions,1)} = 0;
          Object.Arcs_Upper_Variables{size(Object.Places,1),size(Object.Transitions,1)} = inf;
          Object.Arcs_Effect_Variables{size(Object.Places,1),size(Object.Transitions,1)} = 0;
        end
      end
      for i = 1:size( Object.Places, 1 )
        for j = 1:size( Object.Transitions, 1 )
          for k = size( Object.Arcs_Lower{i,j},1)+1:size(Object.Colors,1)
            Object.Arcs_Lower{i,j}(k,1) = 0;
          end
          for k = size( Object.Arcs_Upper{i,j},1)+1:size(Object.Colors,1)
            Object.Arcs_Upper{i,j}(k,1) = inf;
          end
          for k = size( Object.Arcs_Effect{i,j},1)+1:size(Object.Colors,1)
            Object.Arcs_Effect{i,j}(k,1) = 0;
          end
          for k = size( Object.Arcs_Lower_Variables{i,j},1)+1:size(Object.Variables,1)
            Object.Arcs_Lower_Variables{i,j}(k,1) = 0;
          end
          for k = size( Object.Arcs_Upper_Variables{i,j},1)+1:size(Object.Variables,1)
            Object.Arcs_Upper_Variables{i,j}(k,1) = inf;
          end
          for k = size( Object.Arcs_Effect_Variables{i,j},1)+1:size(Object.Variables,1)
            Object.Arcs_Effect_Variables{i,j}(k,1) = 0;
          end
        end
      end
      Object.Current = Object.Initial;
      if ishandle( Object.Handle )
        Object.ViewImage;
      end
    end

    %% ParseArc
    %> Parses an Arc Identifier.
    %> - Parses an arc to a Source,Destination,Type triplet.
    %> - Recognized arc types:
    %>   - -> Regular Arc
    %>   - -o Inhibior Arc
    %>   - -* Read Arc
    %>   - -- Range Arc
    %>
    %> ### Input Signatures
    %>> PN.ParseArc( \<ArcID\> )
    %> ### Output Signature
    %>> [Type,Source,Destination,Exception] = PN.ParseArc()
    %> - Type stores the arc type.
    %> - Source stores the source ID of the arc.
    %> - Destination stores the destination ID of the arc.
    %> - Exception stores the last active exception.
    function [Type,Source,Destination,Exception] = ParseArc( Object, Name )
      Exception = 'E_NONE';
      Type = '';
      TypeId = '';
      Source = '';
      Destination = '';
      if ~isempty( strfind( Name, '--' ) )
        Type = 'Range';
        TypeId = '--';
      end
      if ~isempty( strfind( Name, '->' ) )
        Type = 'Regular';
        TypeId = '->';
      end
      if ~isempty( strfind( Name, '<-' ) )
        Type = 'Regular';
        TypeId = '<-';
      end
      if ~isempty( strfind( Name, '-o' ) )
        Type = 'Inhibit';
        TypeId = '-o';
      end
      if ~isempty( strfind( Name, 'o-' ) )
        Type = 'Inhibit';
        TypeId = 'o-';
      end
      if ~isempty( strfind( Name, '-*' ) )
        Type = 'Read';
        TypeId = '-*';
      end
      if ~isempty( strfind( Name, '*-' ) )
        Type = 'Read';
        TypeId = '*-';
      end
      if ~isempty( strmatch( Type, '' ) )
        Object.CreateMessage('Exception Handling',{'Function: ParseArc';'Exception: E_TYPE'},'Error');
        Exception = 'E_TYPE';
      else
        Source = Name(1:strfind( Name, TypeId )-1 );
        Destination = Name(strfind( Name, TypeId )+2:length(Name));
        switch TypeId
          case {'*-','<-','o-'}
            Tmp = Destination;
            Destination = Source;
            Source = Tmp;
        end
      end
    end

    %% ParseBindingPart
    %> Parses a single element of a binding.
    %> - Parses an element of the form '\<VarID\>=\<ColID\>' to a seperate VarID and ColID.
    %>
    %> ### Input Signatures
    %>> PN.ParseBindingPart( \<BindingElement\> )
    %> ### Output Signature
    %>> [Boolean,Variable,Color] = PN.ParseBindingPart()
    %> - Boolean stores whether the result is usefull.
    %> - Variable stores the \<VarID\> denoted above.
    %> - Color stores the \<ColID\> denoted above.
    function [Boolean,Variable,Color] = ParseBindingPart( Object, BindingPart )
      Boolean = 1;
      Color = '';
      Variable = BindingPart(1:strfind(BindingPart,'=')-1);
      if ~strcmp( Object.GetType( Variable ), 'Variable' ) 
        Boolean = 0;
        Variable = '';
      end
      if Boolean
        Color = BindingPart(strfind(BindingPart,'=')+1:length(BindingPart));
        if ~strcmp( Object.GetType( Color ), 'Color' ) 
          Boolean = 0;
          Variable = '';
          Color = '';
        end
      end
      if Boolean
        VarIdx = Object.RetrieveIndex('Variable',Variable);
        ColorSet = Object.Variables{VarIdx,2};
        if ~Object.InColorSet( Color, ColorSet )
          Boolean = 0;
          Variable = '';
          Color = '';
        end
      end
    end
    
    %% ParseBinding
    %> Parses a full binding.
    %> - Calls PN.ParseBindingPart() for each element of the binding.
    %>
    %> ### Input Signatures
    %>> PN.ParseBinding( {\<BindingPart_1\>;...;<\BindingPart_n\>})
    %> ### Output Signature
    %>> [Boolean,Binding] = PN.ParseBinding()
    %> - Boolean stores whether the function has succesfully parsed the binding
    %> - Binding stores for each variable, a color that it is bound to.
    function [Boolean,Binding] = ParseBinding( Object, AllBindings )
      Boolean = 1;
      Binding = cell(size(Object.Variables,1),1);
      for i = 1:size( AllBindings, 1 )
        [Bool,Var,Col] = Object.ParseBindingPart( AllBindings{i} );
        if Bool
          VarIdx = Object.RetrieveIndex('Variable',Var);
          Binding{ VarIdx } = Col;
        else
          Boolean = 0;
        end
      end
    end
    
    %% ResolveBinding
    %> Parses Values according to a Binding.
    %> - Parses a Binding with Corresponding Variable-Based values into Color-Based values.
    %>
    %> ### Input Signatures
    %>> PN.ResolveBinding( \<Binding\>, \<Values\> )
    %> - \<Binding\> Expects a result from ParseBinding.
    %> - Together with Variable-Indexed Values, parses this to a set of Color-Indexed Values.
    %>
    %> ### Output Signature
    %>> [Boolean,ResolvedBinding] = PN.ResolveBinding()
    %> - Boolean stores whether the binding could be resolved.
    %> - ResolvedBinding stores for each the color the seperate values needed.
    function [Boolean,ResolvedBinding] = ResolveBinding( Object, FullBinding, Values )
      [~,Binding] = Object.ParseBinding(FullBinding);
      Boolean = 1;
      ResolvedBinding = zeros(size(Object.Colors,1),1);
      for i = 1:size(Binding,1)
        if isempty(Binding{i}) && Values(i) > 0
          Boolean = 0;
        end
        if Boolean
          ColIdx = Object.RetrieveIndex('Color',Binding{i});
          ResolvedBinding(ColIdx) = ResolvedBinding(ColIdx) + Values(i);
        end
      end
      if ~Boolean || isempty( Values ) || isempty( FullBinding )
        ResolvedBinding = [];
      end
    end
    
    %% GetAssociatedVariables
    %> Gets a list of variables associated to a Transition.
    %> - Gets a list of variables associated to a Transition.
    %>
    %> ### Input Signature
    %>> PN.GetAssociatedVariables( \<TransitionID\> )
    %> ### Output Signature
    %>> [Variables] = PN.GetAssociatedVariables()
    %> - Variables stores a cellmatrix of all variable ID's that are associated to the transtion.
    function [Variables] = GetAssociatedVariables( Object, Transition )
      TransIdx = Object.RetrieveIndex( 'Transition', Transition );
      TmpVals = zeros(size(Object.Variables,1),1);
      for i = 1:size(Object.Places,1)
        TmpVals = TmpVals + abs( Object.Arcs_Effect_Variables{i,TransIdx} );
        TmpVals = TmpVals + abs( Object.Arcs_Lower_Variables{i,TransIdx} );
        TmpVals = TmpVals + ~isinf( Object.Arcs_Upper_Variables{i,TransIdx} );
      end
      TmpVariables = Object.Variables(:,1);
      Variables = TmpVariables( TmpVals ~= 0 );
    end

    %% GenerateDotDescription
    %> Generates a description that can be given to the 'Dot' tool.
    function Dot = GenerateDotDescription( Object )
      Dot = 'digraph G{ node [shape="Mrecord"]; splines=true; ';
      for i = 1:size(Object.Places,1)
        Dot = [Dot,'"',Object.Places{i,1},'" [label="',Object.Places{i},'|{'; ];
        MyColors = [];
        for j = 1:size( Object.Colors, 1 )
          if Object.InColorSet( Object.Colors{j}, Object.Places{i,2} )
            MyColors = [MyColors;j];
          end
        end
        for j = 1:size( MyColors,1)
            if j ~= 1
                Dot = [Dot,'|'];
            end
            Dot = [Dot,'{',Object.Colors{MyColors(j),1},'|',int2str(Object.Current(MyColors(j),i)),'}'];
        end
        Dot = [Dot,'}"] ;'];
      end
      Dot = [Dot,'node [shape=rectangle]; '];
      for i = 1:size( Object.Transitions, 1 )
        if Object.Transitions{i}(1) == '_'
          Dot = [Dot,'"',Object.Transitions{i},'" [label="_"'];
        else
          Dot = [Dot,'"',Object.Transitions{i},'" [label="',Object.Transitions{i},'"'];
        end
        if Object.HasConcession( Object.Transitions{i} )
          Dot = [Dot,',style=filled,fillcolor=green'];
        end
        Dot = [Dot,'] ;'];
      end
      for i = 1:size(Object.Places,1)
        for j = 1:size(Object.Transitions,1)
          RegPT = 0;
          RegTP = 0;
          Inh = 0;
          Read = 0;
          ThisEff = [Object.Arcs_Effect{i,j};Object.Arcs_Effect_Variables{i,j}];
          ThisLow = [Object.Arcs_Lower{i,j};Object.Arcs_Lower_Variables{i,j}];
          ThisUpp = [Object.Arcs_Upper{i,j};Object.Arcs_Upper_Variables{i,j}];
          for k = 1:size( ThisEff, 1 )
            if ThisEff(k) < 0
              RegPT = 1;
            end
            if ThisEff(k) > 0
              RegTP = 1;
            end
            if ( ThisLow(k) > 0 && ThisEff(k) == 0 ) || ( ThisLow(k) - abs(ThisEff(k)) ) > 0
              Read = 1;
            end
            if ~isinf(ThisUpp(k))
              Inh = 1;
            end
          end
          if RegPT && RegTP
            Dot = [Dot,'"',Object.Places{i},'" -> "',Object.Transitions{j},'" [arrowhead=vee,arrowtail=vee,dir=both];'];
          elseif RegPT
            Dot = [Dot,'"',Object.Places{i},'" -> "',Object.Transitions{j},'" [arrowhead=vee];'];
          elseif RegTP
            Dot = [Dot,'"',Object.Transitions{j},'" -> "',Object.Places{i},'" [arrowhead=vee];'];
          end
          if Read
            Dot = [Dot,'"',Object.Places{i},'" -> "',Object.Transitions{j},'" [arrowhead=dot];'];
          end
          if Inh
            Dot = [Dot,'"',Object.Places{i},'" -> "',Object.Transitions{j},'" [arrowhead=odot];'];
          end
        end
      end
    end
    
    %% CreateFromSnoopy
    %> Creates a new net by parsing a snoopy file.
    %> ### Input Signatures
    %>> PN.CreateFromSnoopy( \<FileName\> )
    %> - Creates a net by parsing the snoopy file \<FileName\>.
    %>
    %> ### Output Signature
    %>> PN.CreateFromSnoopy()
    %> - No return values
    function CreateFromSnoopy( Obj, FileName )
      XMLdoc = xmlread(FileName);
      AllMetadataTypes = XMLdoc.getElementsByTagName('metadataclass');
      ReadSimpleColors = 0;
      ReadProductColors = 0;
      ReadVariables = 0;
      while ~ReadVariables;
        for i=0:AllMetadataTypes.getLength-1
          CurMetadata = AllMetadataTypes.item(i);
          if ~ReadSimpleColors && strcmp( char( CurMetadata.getAttribute('name') ), 'Basic Colorset Class' )
            AllAttribs = CurMetadata.getElementsByTagName('attribute');
            for j=0:AllAttribs.getLength-1
              ThisAttrib = AllAttribs.item(j);
              if strcmp( char( ThisAttrib.getAttribute('name') ), 'ColorsetList' )
                ThisColList = ThisAttrib.getElementsByTagName('colList_row');
                for k=0:ThisColList.getLength-1
                  ThisRow = ThisColList.item(k);
                  ThisColumns = ThisRow.getElementsByTagName('colList_col');
                  SetName = strtrim( char( ThisColumns.item(0).getChildNodes.item(1).getData ) );
                  SetType = strtrim( char( ThisColumns.item(1).getChildNodes.item(1).getData ) );
                  SetValues = strtrim( char( ThisColumns.item(2).getChildNodes.item(1).getData ) );
                  switch( SetType )
                    case 'dot'
                      Obj.Add('ColorSet',SetName,'dot');
                    case 'enum'
                      Obj.Add('ColorSet',SetName,SetValues);
                  end
                end
                ReadSimpleColors = 1;
              end
            end
          end
          if ~ReadProductColors && ReadSimpleColors && strcmp( char( CurMetadata.getAttribute('name') ), 'Structured Colorset Class' )
            AllAttribs = CurMetadata.getElementsByTagName('attribute');
            for j=0:AllAttribs.getLength-1
              ThisAttrib = AllAttribs.item(j);
              if strcmp( char( ThisAttrib.getAttribute('name') ), 'StructuredColorsetList' )
                ThisColList = ThisAttrib.getElementsByTagName('colList_row');
                for k=0:ThisColList.getLength-1
                  ThisRow = ThisColList.item(k);
                  ThisColumns = ThisRow.getElementsByTagName('colList_col');
                  SetName = strtrim( char( ThisColumns.item(0).getChildNodes.item(1).getData ) );
                  SetType = strtrim( char( ThisColumns.item(1).getChildNodes.item(1).getData ) );
                  SetValues = strtrim( char( ThisColumns.item(2).getChildNodes.item(1).getData ) );
                  switch( SetType )
                    case 'product'
                      Separator = strfind( SetValues, ',' );
                      Obj.Add('ColorSet',SetName,SetValues(1:Separator(1)-1),SetValues(Separator(1)+1:length(SetValues)));
                  end
                end
                ReadProductColors = 1;
              end
            end
          end
          if ReadProductColors && ReadSimpleColors && strcmp( char( CurMetadata.getAttribute('name') ), 'Variable Class' )
            AllAttribs = CurMetadata.getElementsByTagName('attribute');
            for j=0:AllAttribs.getLength-1
              ThisAttrib = AllAttribs.item(j);
              if strcmp( char( ThisAttrib.getAttribute('name') ), 'VariableList' )
                ThisColList = ThisAttrib.getElementsByTagName('colList_row');
                for k=0:ThisColList.getLength-1
                  ThisRow = ThisColList.item(k);
                  ThisColumns = ThisRow.getElementsByTagName('colList_col');
                  VarName = strtrim( char( ThisColumns.item(0).getChildNodes.item(1).getData ) );
                  VarSet = strtrim( char( ThisColumns.item(1).getChildNodes.item(1).getData ) );
                  Obj.Add('Variable',VarName,VarSet);
                end
                ReadVariables = 1;
              end
            end
          end
        end
      end
      AllNodeTypes = XMLdoc.getElementsByTagName('nodeclass');
      AllIDs = {};
      for i=0:AllNodeTypes.getLength-1
        CurNodeType = AllNodeTypes.item(i);
        switch char( CurNodeType.getAttribute('name') )
          case 'Place'
            AllPlaces = CurNodeType.getElementsByTagName('node');
            display( ['Reading Places: ', int2str( AllPlaces.getLength )] );
            for j=0:AllPlaces.getLength-1
              display( [int2str( j / AllPlaces.getLength * 100 ), '%' ] );
              CurPlace = AllPlaces.item(j);
              NodeID = char(CurPlace.getAttribute('id'));
              ThisName = '';
              ThisID = '';
              ThisMarking = '';
              ThisColorSet = '';
              AllMarkings = zeros(size(Obj.Colors,1),1);
              AllAttribs = CurPlace.getElementsByTagName('attribute');
              for k=0:AllAttribs.getLength-1
                CurAttrib = AllAttribs.item(k);
                switch char( CurAttrib.getAttribute('name') )
                  case 'Name'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisName = char( CurAttrib.getChildNodes.item(l).getData );
                      end
                    end
                  case 'ID'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisID = ['Place_',char( CurAttrib.getChildNodes.item(l).getData )];
                      end
                    end
                  case 'Marking'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisMarking = char( CurAttrib.getChildNodes.item(l).getData );
                      end
                    end
                  case 'Colorset'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisColorSet = char( CurAttrib.getChildNodes.item(l).getData );
                      end
                    end
                  case 'MarkingList'
                    MyColRows = CurAttrib.getElementsByTagName('colList_row');
                    for l=0:MyColRows.getLength-1
                      CurColorItem = MyColRows.item(l);
                      MyColorColumns = CurColorItem.getElementsByTagName('colList_col');
                      CurCol =  char( MyColorColumns.item(0).getChildNodes.item(1).getData );
                      CurAmount = char( MyColorColumns.item(1).getChildNodes.item(1).getData );
                      if ~strcmp( CurCol, 'all()' )
                        ColorIdx = Obj.RetrieveIndex( 'Color', CurCol );
                        AllMarkings(ColorIdx) = AllMarkings(ColorIdx) + str2double(CurAmount);
                      end
                    end
                end
              end
              if strcmp(ThisName,'')
                ThisName = ThisID;
              end
              AllIDs{size(AllIDs,1)+1,1} = NodeID;
              AllIDs{size(AllIDs,1),2} = ThisName;
              if strcmp( ThisColorSet, '' )
                if ~strcmp(ThisMarking,'')
                  Obj.Add( 'Place', ThisName, 'Dot', [ThisMarking '.'] );
                else
                  Obj.Add( 'Place', ThisName );
                end
              else
                Obj.Add( 'Place', ThisName, ThisColorSet );
                Tmp = find( AllMarkings );
                MyMarking = {};
                for l=1:size(Tmp,1)
                  if Obj.InColorSet(Obj.Colors{Tmp(l),1},ThisColorSet)
                    MyMarking = [MyMarking;{[int2str(AllMarkings(Tmp(l))),Obj.Colors{Tmp(l),1}]} ];
                  end
                end
                Obj.SetInitial( ThisName, MyMarking );
              end
            end
          case 'Transition'
            AllTrans = CurNodeType.getElementsByTagName('node');
            display( ['Reading Transitions: ', int2str( AllTrans.getLength )] );
            for j=0:AllTrans.getLength-1
              display( [int2str( j / AllTrans.getLength * 100 ), '%' ] );
              CurTrans = AllTrans.item(j);
              NodeID = char(CurTrans.getAttribute('id'));
              ThisName = '';
              ThisID = '';
              AllAttribs = CurTrans.getElementsByTagName('attribute');
              for k=0:AllAttribs.getLength-1
                CurAttrib = AllAttribs.item(k);
                switch char( CurAttrib.getAttribute('name') )
                  case 'Name'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisName = char( CurAttrib.getChildNodes.item(l).getData );
                      end
                    end
                  case 'ID'
                    for l=0:CurAttrib.getChildNodes.getLength-1
                      if CurAttrib.getChildNodes.item(l).getNodeType == XMLdoc.CDATA_SECTION_NODE
                        ThisID = ['Transition_',char( CurAttrib.getChildNodes.item(l).getData )];
                      end
                    end
                end
              end
              if strcmp(ThisName,'')
                ThisName = ThisID;
              end
              AllIDs{size(AllIDs,1)+1,1} = NodeID;
              AllIDs{size(AllIDs,1),2} = ThisName;
              Obj.Add( 'Transition', ThisName );
            end
        end
      end
      AllEdgeTypes = XMLdoc.getElementsByTagName('edgeclass');
      for l=0:AllEdgeTypes.getLength-1
        CurEdgeType = AllEdgeTypes.item(l);
        switch char( CurEdgeType.getAttribute('name') )
          case 'Edge'
            AllEdges = CurEdgeType.getElementsByTagName('edge');
            display( ['Reading Regular Arcs: ', int2str( AllEdges.getLength )] );
            for i=0:AllEdges.getLength-1
              display( [int2str( i / AllEdges.getLength * 100 ), '%' ] );
              CurEdge = AllEdges.item(i);
              Multiply = '';
              Expression = '';
              for j = 0:CurEdge.getElementsByTagName('attribute').getLength-1
                CurAtt = CurEdge.getElementsByTagName('attribute').item(j);
                if strcmp( char(CurAtt.getAttribute('name')), 'Multiplicity' )
                  for k=0:CurAtt.getChildNodes.getLength-1
                    if CurAtt.getChildNodes.item(k).getNodeType == XMLdoc.CDATA_SECTION_NODE
                      Multiply = strtrim( char( CurAtt.getChildNodes.item(k).getData ) );
                    end
                  end
                end
                if strcmp( char( CurAtt.getAttribute('name')), 'ExpressionList' )
                    MyExpression = CurAtt.getElementsByTagName('colList_col').item(1);
                    Expression = strtrim( char( MyExpression.getChildNodes.item(1).getData ) );
                end
              end
              SrcID = char(CurEdge.getAttribute('source'));
              SrcIdx = find( strcmp( AllIDs(:,1), SrcID ), 1 );
              Src = AllIDs{SrcIdx,2};
              DstID = char(CurEdge.getAttribute('target'));
              DstIdx = find( strcmp( AllIDs(:,1), DstID ), 1 );
              Dst = AllIDs{DstIdx,2};
              ThisName = [Src '->' Dst];
              if strcmp( Expression, '' )
                  if strcmp( Multiply, '' )
                    Obj.Add( 'Arc', ThisName, '1.' );
                  else
                    Obj.Add( 'Arc', ThisName, [Multiply,'.'] );
                  end
              else
                  Obj.Add( 'Arc', ThisName, Expression );
              end
            end
          case 'Read Edge'
            AllEdges = CurEdgeType.getElementsByTagName('edge');
            display( ['Reading Read Arcs: ', int2str( AllEdges.getLength )] );
            for i=0:AllEdges.getLength-1
              display( [int2str( i / AllEdges.getLength * 100 ), '%' ] );
              CurEdge = AllEdges.item(i);
              Multiply = '';
              Expression = '';
              for j = 0:CurEdge.getElementsByTagName('attribute').getLength-1
                CurAtt = CurEdge.getElementsByTagName('attribute').item(j);
                if strcmp( char(CurAtt.getAttribute('name')), 'Multiplicity' )
                  for k=0:CurAtt.getChildNodes.getLength-1
                    if CurAtt.getChildNodes.item(k).getNodeType == XMLdoc.CDATA_SECTION_NODE
                      Multiply = strtrim( char( CurAtt.getChildNodes.item(k).getData ) );
                    end
                  end
                end
                if strcmp( char( CurAtt.getAttribute('name')), 'ExpressionList' )
                    MyExpression = CurAtt.getElementsByTagName('colList_col').item(1);
                    Expression = strtrim( char( MyExpression.getChildNodes.item(1).getData ) );
                end
              end
              SrcID = char(CurEdge.getAttribute('source'));
              SrcIdx = find( strcmp( AllIDs(:,1), SrcID ), 1 );
              Src = AllIDs{SrcIdx,2};
              DstID = char(CurEdge.getAttribute('target'));
              DstIdx = find( strcmp( AllIDs(:,1), DstID ), 1 );
              Dst = AllIDs{DstIdx,2};
              ThisName = [Src '-*' Dst];
              if strcmp( Expression, '' )
                  if strcmp( Multiply, '' )
                    Obj.Add( 'Arc', ThisName, '1.' );
                  else
                    Obj.Add( 'Arc', ThisName, [Multiply,'.'] );
                  end
              else
                  Obj.Add( 'Arc', ThisName, Expression );
              end
            end
          case 'Inhibitor Edge'
            AllEdges = CurEdgeType.getElementsByTagName('edge');
            display( ['Reading Inhibitor Arcs: ', int2str( AllEdges.getLength )] );
            for i=0:AllEdges.getLength-1
              display( [int2str( i / AllEdges.getLength * 100 ), '%' ] );
              CurEdge = AllEdges.item(i);
              Multiply = '';
              Expression = '';
              for j = 0:CurEdge.getElementsByTagName('attribute').getLength-1
                CurAtt = CurEdge.getElementsByTagName('attribute').item(j);
                if strcmp( char(CurAtt.getAttribute('name')), 'Multiplicity' )
                  for k=0:CurAtt.getChildNodes.getLength-1
                    if CurAtt.getChildNodes.item(k).getNodeType == XMLdoc.CDATA_SECTION_NODE
                      Multiply = strtrim( char( CurAtt.getChildNodes.item(k).getData ) );
                    end
                  end
                end
                if strcmp( char( CurAtt.getAttribute('name')), 'ExpressionList' )
                    MyExpression = CurAtt.getElementsByTagName('colList_col').item(1);
                    Expression = strtrim( char( MyExpression.getChildNodes.item(1).getData ) );
                end
              end
              SrcID = char(CurEdge.getAttribute('source'));
              SrcIdx = find( strcmp( AllIDs(:,1), SrcID ), 1 );
              Src = AllIDs{SrcIdx,2};
              DstID = char(CurEdge.getAttribute('target'));
              DstIdx = find( strcmp( AllIDs(:,1), DstID ), 1 );
              Dst = AllIDs{DstIdx,2};
              ThisName = [Src '-o' Dst];
              if strcmp( Expression, '' )
                  if strcmp( Multiply, '' )
                    Obj.Add( 'Arc', ThisName, '1.' );
                  else
                    Obj.Add( 'Arc', ThisName, [Multiply,'.'] );
                  end
              else
                  Obj.Add( 'Arc', ThisName, Expression );
              end
            end
        end
      end
    end
    
    %% CreateFromPNML
    %> Creates a new net by parsing a PNML (PetriNet Markup Language) file.
    %> ### Input Signatures
    %>> PN.CreateFromSnoopy( \<FileName\> )
    %> - Creates a net by parsing the snoopy file \<FileName\>.
    %>
    %> ### Output Signature
    %>> PN.CreateFromSnoopy()
    %> - No return values
    function CreateFromPNML( Obj, FileName )
      XMLdoc = xmlread( FileName );
      %Name = XMLdoc.getElementsByTagName('text').item(0).getFirstChild.getData;
      AllIDs = {};
      AllPlaces = XMLdoc.getElementsByTagName('place');
      display( ['Place amount: ', int2str( AllPlaces.getLength )] );
      for i=0:AllPlaces.getLength-1;
        display( ['  Progress: ', int2str( i/AllPlaces.getLength*100 ), '%' ] )
        ThisPlace = AllPlaces.item(i);
        ThisName = char(ThisPlace.getElementsByTagName('text').item(0).getFirstChild.getData);
        ThisMarking = ThisPlace.getElementsByTagName('initialMarking');
        if ThisMarking.getLength
          ThisMarking = char(ThisMarking.item(0).getElementsByTagName('text').item(0).getFirstChild.getData);
          Obj.Add( 'Place', ThisName, [ThisMarking '.'] );
        else
          Obj.Add( 'Place', ThisName );
        end
        AllIDs{size(AllIDs,1)+1,1} = char(ThisPlace.getAttribute('id'));
        AllIDs{size(AllIDs,1),2} = ThisName;
      end
      AllTransitions = XMLdoc.getElementsByTagName('transition');
      display( ['Transition amount: ', int2str( AllTransitions.getLength )] );
      AnonTransNum = 1;
      for i=0:AllTransitions.getLength-1;
        display( ['  Progress: ', int2str( i/AllTransitions.getLength*100 ), '%' ] )
        ThisTrans = AllTransitions.item(i);
        if ThisTrans.getLength
          ThisName = char(ThisTrans.getElementsByTagName('text').item(0).getFirstChild.getData);
        else
          ThisName = ['Trans',int2str(AnonTransNum)];
          AnonTransNum = AnonTransNum + 1;
        end
        Obj.Add( 'Transition', ThisName );
        AllIDs{size(AllIDs,1)+1,1} = char(ThisTrans.getAttribute('id'));
        AllIDs{size(AllIDs,1),2} = ThisName;
      end
      AllArcs = XMLdoc.getElementsByTagName('arc');
      display( ['Arc amount: ', int2str( AllArcs.getLength )] );
      for i=0:AllArcs.getLength-1;
        display( ['  Progress: ', int2str( i/AllArcs.getLength*100 ), '%' ] )
        ThisArc = AllArcs.item(i);
        SrcID = char(ThisArc.getAttribute('source'));
        SrcIdx = find( strcmp( AllIDs(:,1), SrcID ), 1 );
        Src = AllIDs{SrcIdx,2};
        DstID = char(ThisArc.getAttribute('target'));
        DstIdx = find( strcmp( AllIDs(:,1), DstID ), 1 );
        Dst = AllIDs{DstIdx,2};
        ThisName = [Src '->' Dst];
        if ThisArc.getElementsByTagName('text').getLength
          ThisInscription = char(ThisArc.getElementsByTagName('text').item(0).getFirstChild.getData);
          Obj.Add( 'Arc', ThisName, [ThisInscription '.'] );
        else
          Obj.Add( 'Arc', ThisName, '1.' );
        end
      end
    end
  end
  
%% Debug Private Methods
  methods( Access = private )
    %% GeneratePopup
    %> Creates a pop-up message
    %> - Creates a msgbox with the correct parameters
    %> - Assigns to correct colormap to the types of messages.
    %> - Uses a default colormap if the message type is not recognized.
    %>
    %> ### Input Signatures
    %>> PN.GeneratePopup( \<Title\>, \<Message\>, \<Type\> )
    %> - Creates a pop-up message with \<Title\>, \<Message\>, of type \<Type\> 
    %>
    %> ### Output Signature
    %>> PN.GeneratePopup()
    %> - No return values
    function GeneratePopup(Object, Title, Message, Type )
      ColorMap = [0.7 0.7 0.7;1 1 1;1 1 1;0 0 0];
      switch Type
        case 'Debug'
          ColorMap = Object.DebugColors;
        case 'Warning'
          ColorMap = Object.WarningColors;
        case 'Error'
          ColorMap = Object.ErrorColors;
      end
      msgbox(Message,[Type,': ',Title],'custom',Object.IconData,ColorMap);
    end
    
    %% CreateMessage
    %>Creates a message, and adds it to the stack
    %> - Saves the parameters for later use in GeneratePopup
    %>
    %> ### Input Signatures
    %>> PN.CreateMessage( \<Title\>, \<Message\>, \<Type\> )
    %> - Creates a message with \<Title\>, \<Message\>, of type \<Type\> 
    %>
    %> ### Output Signature
    %>> PN.CreateMessage()
    %> - No return values
    function CreateMessage(Object,Title,Message,Type)
      MsgIdx = size( Object.AllMessages, 1) + 1;
      Object.AllMessages{MsgIdx,1} = Title;
      Object.AllMessages{MsgIdx,2} = Message;
      Object.AllMessages{MsgIdx,3} = Type;
    end
    
    %% ParseAllMessages
    %> Parse all messages and generates the appropriate pop-up boxes.
    %> - Always generates 'Error' and 'Warning' messages.
    %> - If DebugObject is greater than 0, will also generate all other messages.
    %> - Erases the stack of messages after parsing
    %>
    %> ### Input Signatures
    %>> PN.ParseAllMessages( )
    %> - Parses all the messages in the structure, and generates pop-up boxes.
    %>
    %> ### Output Signature
    %>> PN.ParseAllMessages()
    %> - No return values
    function ParseAllMessages(Object)
      for i = 1:size(Object.AllMessages,1)
        Idx = size(Object.AllMessages,1) - (i - 1);
        Title = Object.AllMessages{Idx,1};
        Message = Object.AllMessages{Idx,2};
        Type = Object.AllMessages{Idx,3};
        if ~isempty(strmatch( Type, 'Warning' )) || ~isempty(strmatch( Type, 'Error' )) || Object.DebugObject
          Object.GeneratePopup(Title,Message,Type);
        end
      end
      Object.AllMessages = {};
    end
    
  end
  
%% Static Methods
  methods( Static )%, Access = private )
    %% RemoveFromMatrix
    %>Removes a row/column/slice from a matrix.
    %>
    %> ### Input Signatures
    %>> PN.RemoveFromMatrix(\<Matrix\>,1,\<Index\>)
    %> - Remove the row with index \<Index\> from \<Matrix\>.
    %>
    %>> PN.RemoveFromMatrix(\<Matrix\>,2,\<Index\>)
    %> - Remove the column with index \<Index\> from \<Matrix\>.
    %>
    %>> PN.RemoveFromMatrix(\<Matrix\>,\<Slice\>,\<Index\>)
    %> - Remove the slice with index \<Slice\> from \<Matrix\>.
    %>
    %> ### Output Signature
    %>> [Matrix,Exception] = PN.RemoveFromMatrix()

    %>\exception 'E_NONE' No exception thrown
    %>\exception 'E_DIM' Dimension is not a valid dimension for the given Matrix.
    %>\exception 'E_INDEX' Index is not a valid index for the given dimension.
    function [Matrix,Exception] = RemoveFromMatrix( Matrix, Dimension, Index )
      Exception = 'E_NONE';
      % Error Checking
      if Dimension > ndims( Matrix ) || Dimension < 1
        Exception = 'E_DIM';
      end
      if Index > size( Matrix, Dimension ) || Index < 1
        Exception = 'E_INDEX';
      end
      if ~strcmp( Exception, 'E_NONE' )
        return;
      end
      % Shift Matrix to locate the slice to remove to the back
      ShiftMat = zeros( 1, ndims( Matrix ) );
      ShiftMat( Dimension ) = -Index;
      TempMat = circshift( Matrix, ShiftMat );
      ShiftMat( Dimension ) = Index - 1;
      % Generate a multidimensional string to cut off the slice.
      EvalString = 'TempMat(';
      for i=1:ndims( TempMat )
        if i ~= 1
          EvalString = [EvalString ',']; %#ok<*AGROW>
        end
        if i == Dimension
          EvalString = [EvalString '1:' num2str( size(TempMat,Dimension) - 1 )];
        else
          EvalString = [EvalString ':'];
        end
      end
      EvalString = [EvalString ')'];
      % Shift Matrix back to original position, as well as evaluate the cutoff.
      Matrix = circshift( eval( EvalString ), ShiftMat );
    end
  end

%% Public Methods
  methods
    %% PN
    %>Creates a new PetriNet.
    %> - This constructor function will create a new PetriNet, and initialize it with the appropriate values.
    %> - Use the debug option with care.
    %>
    %> ### Input Signatures
    %>> PN.PN()
    %> Produces an empty net.
    %>> PN.PN(\<FileName\>)
    %> Produces a net initialized with the values in the file, or an empty net if the file name is invalid.
    %>> PN.PN(\<FileName\>,'DEBUG')
    %> Produces a debug net initialized with the values in the file, or an empty net if the file name is invalid.
    %>
    %> ### Output Signature
    %>> [Object,Exception] = PN.PN()
    %> - Stores the created net into the variable 'Object'.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\exception E_NONE No exception thrown.
    %>\exception E_FILETYPE The type of the file is not recognized as a valid input.
    function [Object,Exception] = PN( varargin )
      % If the second parameter is "DEBUG", we want to create some more verbose debugging.
      if size(varargin,2) > 1 && strmatch( varargin{2}, 'DEBUG' )
        Object.CreateMessage( 'Debug Message',{'Function: PN';'Message: Creating a DEBUG object'},'Debug');
        Object.DebugObject = 1;
      end
      if size(varargin,2) < 1 || strcmp( varargin{1}, '' )
        % No parameters or no filename given, produce an empty net.
        Object.CreateMessage( 'Debug Message',{'Function: PN';'Message: Initializing an empty net'},'Debug');
        Exception = Object.InitializeEmptyNet();
      else
        % Parse the extension of the file and select the right function to call
        FileType = varargin{1}(strfind(varargin{1},'.')+1:length(varargin{1}));
        switch( FileType )
          case 'spped'
            % In case of a non-colored net, we need to initialize the 'Dot' colorset, among others, for compatibility.
            Object.InitializeEmptyNet();
            Object.CreateFromSnoopy( varargin{1} );
          case 'spept'
            % In case of a non-colored net, we need to initialize the 'Dot' colorset, among others, for compatibility.
            Object.InitializeEmptyNet();
            Object.CreateFromSnoopy( varargin{1} );
          case 'colpn'
            Object.CreateFromSnoopy( varargin{1} );
          case 'colextpn'
            Object.CreateFromSnoopy( varargin{1} );
          case 'pnml'
            Object.InitializeEmptyNet();
            Object.CreateFromPNML( varargin{1} );
          otherwise
            % Extension not recognized. Throw an exception and a warning, but still create an empty net.
            Object.CreateMessage( 'Exception Handling',{'Function: PN';'Exception: E_FILETYPE'},'Warning');
            Exception = 'E_FILETYPE';
            Object.InitializeEmptyNet();
        end
      end
      % Show all messages that have been generated by myself and/or called functions.
      Object.ParseAllMessages();
    end
    
    %% Add
    %>Add an entry to the net
    %> - Adds an entry to the net
    %> - Checks for ),uniqueness and other constraints
    %> - Optionally sets initial values
    %>
    %> ### Input signatures
    %>> PN.Add(Object,'Place',\<PlaceID\>)\n
    %>> PN.Add(Object,'Place',\<PlaceID\>,\<ColorSetID\>)\n
    %>> PN.Add(Object,'Place',\<PlaceID\>,\<ColorSetID\>,\<InitialMarking_1\>,...,\<InitialMarking_n\>)
    %> - Creates a new place in the net 'Object', with identifier \<PlaceID\>.
    %>   - Optionally sets a different binding \<ColorSet\> for the place. Default is 'Dot'.
    %>   - Optionally gives the place an initial marking.
    %>
    %>> PN.Add(Object,'Transition',\<TransitionID\>)
    %> - Creates a new transition in the net 'Object', with identifier \<TransitionID\>.
    %>
    %>> PN.Add(Object,'ColorSet',\<ColorSetID\>,\<ColorID_1\>,...,\<ColorID_n\>)
    %> - Creates a new *simple* ColorSet in the net 'Object', consisting of the given colors.
    %>
    %>> PN.Add(Object,'ColorSet',\<ColorSetID\>,\<ColorSetID_1\>,\<ColorSetID_2\>)
    %> - Creates a new product ColorSet in the net 'Object', containing all the tuples \f$(x \in \f$\<ColorSetID_1\>\f$,y \in \f$\<ColorSetID_2\>\f$)\f$
    %>
    %>> PN.Add(Object,'Variable',\<VariableID\>,\<ColorSetID\>)
    %> - Creates a new variable in the net 'Object', with identifier \<VariableID\> and valid colors \f$x \in\f$ \<ColorSetID\>
    %>
    %>> PN.Add(Object,'Arc',\<PlaceID\>\<ArcType\>\<TransitionID\>)\n
    %>> PN.Add(Object,'Arc',\<PlaceID\>\<ArcType\>\<TransitionID\>,\<InscriptionPart_1\>,...,\<InscriptionPart_n\>)\n
    %> - Creates an arc between the Place and Transition indicated by their respective ID's.
    %> - ArcType can be any of:
    %>   - -> 'Regular Arc'
    %>   - -o 'Inhibitor Arc'
    %>   - -* 'Read Arc'
    %> - Optionally sets the initial values.
    %>
    %>> PN.Add(Object,'Arc',\<PlaceID\>--\<TransitionID\>)\n
    %>> PN.Add(Object,'Arc',\<PlaceID\>--\<TransitionID\>,\<RangeEffect\>,\<RangeLowerBound\>,\<RangeUpperBound\>)\n
    %> - Creates a range arc between the Place and Transition indicated by their respective ID's.
    %> - Optionally sets the initial values.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.Add()
    %> - Stores the value 1 in the variable 'Boolean' if adding the item succeeded, and 0 if it did not.
    %> - Stores the last active exception in the variable 'Exception'.
    function [Boolean,Exception] = Add( Object, Type, Name, varargin )
      % Check whether the name does not exist yet
      [Boolean,Exception] = Object.IsUnique(Name);
      if ~Boolean
        % Generate an exception + error message
        Object.CreateMessage('Exception Handling',{'Function: Add';['Exception: ',Exception]},'Error');
      else
        % Check which type of item to add
        switch Type
          % Add a place
          case 'Place'
            % Generate a debug message to show that we are going to add a place
            Object.CreateMessage('State Info',{'Function: Add';'Status: Add Place'},'Debug');
            % Check if colorset is known to the net
            ThisColorSet = 'Dot';
            if size( varargin,2 ) > 0
              ThisColorSet = varargin{1};
            end
            if ~strcmp( Object.GetType( ThisColorSet ), 'ColorSet' )
              Boolean = 0;
              Exception = 'E_COLSET';
            end
            if Boolean
              if size( varargin,2 ) > 1
                InitialMarking = cell(size(varargin,2)-1,1);
                for i = 2:size(varargin,2)
                  InitialMarking{i-1,1} = varargin{i};
                end
              else
                InitialMarking = {};
              end
              NewIdx = size( Object.Places, 1 ) + 1;
              Object.Places{NewIdx,1} = Name;
              Object.Places{NewIdx,2} = ThisColorSet;
              Object.SetInitial( Name, InitialMarking );
            end
          case 'Transition'
            Object.CreateMessage('State Info',{'Function: Add';'Status: Add Transition'},'Debug');
            NewIdx = size( Object.Transitions, 1 ) + 1;
            Object.Transitions{ NewIdx, 1 } = Name;
            Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_NONE'},'Debug');
            Exception = 'E_NONE';
          case 'ColorSet'
            Object.CreateMessage('State Info',{'Function: Add';'Status: Add ColorSet'},'Debug');
            TmpType = Object.GetType( varargin{1} );
            if strcmp( TmpType, 'ColorSet' )
              % Product Set
              NewSetIdx = size( Object.ColorSets, 1 ) + 1;
              Object.ColorSets{NewSetIdx,1} = Name;
              ColSet1 = varargin{1};
              ColSet2 = varargin{2};
              ColSetIdx1 = Object.RetrieveIndex( 'ColorSet', ColSet1 );
              ColSetIdx2 = Object.RetrieveIndex( 'ColorSet', ColSet2 );
              ColSetSize1 = size( Object.ColorSets(ColSetIdx1,:), 2 );
              ColSetSize2 = size( Object.ColorSets(ColSetIdx2,:), 2 );
              TmpIdx = 2;
              for i = 2:ColSetSize1
                for j = 2:ColSetSize2
                  NewColor = ['(',Object.ColorSets{ColSetIdx1,i},',',Object.ColorSets{ColSetIdx2,j},')'];
                  Object.ColorSets{NewSetIdx,TmpIdx} = NewColor;
                  TmpIdx = TmpIdx + 1;
                  NewColIdx = size( Object.Colors, 1 ) + 1;
                  Object.Colors{NewColIdx,1} = NewColor;
                  Object.Colors{NewColIdx,2} = Name;
                end
              end
            else
              % Regular Set
              if size(varargin,2) == 1
                Separated = strfind( varargin{1}, ',' );
                if isempty( Separated )
                  ThisVar{1} = varargin{1};
                else
                  ThisVar{1} = varargin{1}(1:Separated(1)-1);
                  for i = 2:size(Separated,2)
                    ThisVar{i} = varargin{1}(Separated(i-1)+1:Separated(i)-1);
                  end
                  ThisVar{size(Separated,2)+1} = varargin{1}(Separated(size(Separated,2))+1:length(varargin{1}));
                end
              else
                for i = 1:size(varargin,2)
                  ThisVar{i} = varargin{i};
                end
              end
              for i = 1:size(ThisVar,2)
                if ~Object.IsUnique( ThisVar{i} )
                  Boolean = 0;
                end
              end
              if Boolean
                NewSetIdx = size( Object.ColorSets, 1 ) + 1;
                Object.ColorSets{NewSetIdx,1} = Name;
                for i = 1:size(ThisVar,2)
                  Object.ColorSets{NewSetIdx,i+1} = ThisVar{i};
                  NewColIdx = size( Object.Colors, 1 ) + 1;
                  Object.Colors{NewColIdx,1} = ThisVar{i};
                  Object.Colors{NewColIdx,2} = Name;
                end
              end
            end
          case 'Variable'
            Object.CreateMessage('State Info',{'Function: Add';'Status: Add Variable'},'Debug');
            ColSet = varargin{1};
            ColSetType = Object.GetType( ColSet );
            if isempty( strcmp( ColSetType, 'ColorSet' ) )
              Object.CreateMessage( 'Exception Handling',{'Function: Add';'Exception: E_TYPE'},'Error');
            else
              NewIdx = size( Object.Variables, 1 ) + 1;
              Object.Variables{NewIdx,1} = Name;
              Object.Variables{NewIdx,2} = ColSet;
            end
          case 'Arc'
            Boolean = 1;
            Object.CreateMessage('State Info',{'Function: Add';'Status: Add Arc'},'Debug');
            [Type,Src,Dst] = Object.ParseArc( Name );
            SrcType = Object.GetType( Src );
            DstType = Object.GetType( Dst );
            if strcmp( SrcType, '' ) || strcmp( DstType, '' )
              Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_TYPE';'Message: No Src or Dst'},'Error');
              Boolean = 0;
            else
              if ( ~isempty( strcmp( Type, 'Inhibit' ) ) ||  ~isempty( strcmp( Type, 'Read' ) ) ) && isempty( strcmp( SrcType, 'Place' ) )
                Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_TYPE';'Message: TxP instead of PxT'},'Error');
                Exception = 'E_TYPE';
                Boolean = 0;
              end
            end
            PlaceIdx = 0;
            TransIdx = 0;
            if strcmp( SrcType, 'Place' ) &&  strcmp( DstType, 'Transition' )
              PlaceIdx = Object.RetrieveIndex( 'Place', Src );
              TransIdx = Object.RetrieveIndex( 'Transition', Dst );
            elseif strcmp( SrcType, 'Transition' ) && strcmp( DstType, 'Place' )
              PlaceIdx = Object.RetrieveIndex( 'Place', Dst );
              TransIdx = Object.RetrieveIndex( 'Transition', Src );
            end
            if ( isempty( PlaceIdx) || ~PlaceIdx ) || (isempty( TransIdx ) || TransIdx == 0)
              Boolean = 0;
            end
            if Boolean
              if strcmp( Type, 'Range' )
                if size( varargin, 2 ) > 2
                  Object.Arcs_Effect{PlaceIdx,TransIdx} = varargin{1};
                  Object.Arcs_Lower{PlaceIdx,TransIdx} = varargin{2};
                  Object.Arcs_Upper{PlaceIdx,TransIdx} = varargin{3};
                end
                if size( varargin, 2 ) > 5
                  Object.Arcs_Effect_Variables{PlaceIdx,TransIdx} = varargin{4};
                  Object.Arcs_Lower_Variables{PlaceIdx,TransIdx} = varargin{5};
                  Object.Arcs_Upper_Variables{PlaceIdx,TransIdx} = varargin{6};
                end
              else
                if size(varargin,2) == 1
                    Separated = strfind( varargin{1}, ';' );
                    if isempty( Separated )
                        ThisVar{1} = varargin{1};
                    else
                        ThisVar{1} = varargin{1}(1:Separated(1)-1);
                        for i = 2:size(Separated,2)
                            ThisVar{i} = varargin{1}(Separated(i-1)+1:Separated(i)-1);
                        end
                        ThisVar{size(Separated,2)+1} = varargin{1}(Separated(size(Separated,2))+1:length(varargin{1}));
                    end
                else
                    for i = 1:size(varargin,2)
                        ThisVar{i} = varargin{i};
                    end
                end
                Object.SetInscription( Name, ThisVar )
              end
            end
          otherwise
            Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_TYPE'},'Error');
            Exception = 'E_TYPE';
            Boolean = 0;
        end 
      end
      Object.Update();
      Object.ParseAllMessages();
    end
    
    %% HasConcession
    %>Determines whether a given function has concession in the current state.
    %> - Calculates concession for a single transition
    %> - Verifies that all necessary bindings have been performed.
    %>
    %> ### Input Signatures
    %>> PN.HasConcession(Object,\<TransitionID\>)
    %>> PN.HasConcession(Object,{\<TransitionID\>;\<Binding_1\>;...;\<Binding_n\>})
    %> - Checks whether the transition with given TransitionID has concession.
    %> - If a binding is given, the corresponding variables will be bound.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.HasConcession()
    %> - Stores the value 1 in the variable 'Boolean' if the transition has concession, and 0 if it does not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = HasConcession( Object, Input )
      if iscell( Input )
        Name = Input{1};
        MyBinding = cell(size(Input,1)-1,1);
        for i = 2:size(Input,1)
          MyBinding{i-1} = Input{i};
        end
      else
        Name = Input;
        MyBinding = {};
      end
      Exception = 'E_NONE';
      Boolean = 1;
      if ~strcmp( Object.GetType( Name ), 'Transition' )
        Boolean = 0;
        Exception = 'E_TYPE';
        Object.CreateMessage( 'Exception Handling',{'Function: HasConcession';'Exception: E_TYPE'},'Error');
      end
      if Boolean
        TransIdx = Object.RetrieveIndex( 'Transition', Name );
      end
      for i = 1:size( Object.Places, 1 )
        if Boolean
          CurrentMarking = Object.Current(:,i);
          LowerBound = Object.Arcs_Lower{i,TransIdx};
          [Bool,LowVar] = Object.ResolveBinding( MyBinding, Object.Arcs_Lower_Variables{i,TransIdx} );
          if Bool
            if ~isempty(LowVar)
              LowerBound = LowerBound + LowVar;
            end
            if ~isempty( LowerBound )
              CheckOnLower = CurrentMarking - LowerBound;
              if ~isempty( find( CheckOnLower < 0, 1 ) )
                Boolean = 0;
              end
            else
              Boolean = 0;
            end
          end
          UpperBound = Object.Arcs_Upper{i,TransIdx};
          [Bool,UppVar] = Object.ResolveBinding( MyBinding, Object.Arcs_Upper_Variables{i,TransIdx} );
          if Bool
            if ~isempty( UppVar )
              UpperBound = UpperBound + UppVar;
            end
            if ~isempty( UpperBound )
              CheckOnUpper = UpperBound - CurrentMarking;
              if ~isempty( find( CheckOnUpper < 0, 1 ) )
                Boolean = 0;
              end
            end
          else
            Boolean = 0;
          end
        end
      end
    end
    
    %% Fire
    %>Fires a transition
    %> - Fires a single transition
    %> - Calls PN.HasConcession() to determine whether the transition can fire.
    %>
    %> ### Input Signatures
    %>> PN.Fire(Object,\<TransitionID\>)
    %>> PN.Fire(Object,{\<TransitionID\>;\<Binding_1\>;...;\<Binding_n\>})
    %> - Checks whether the transition with given TransitionID has concession and fires it.
    %> - If a binding is given, the corresponding variables will be bound.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.Fire()
    %> - Stores the value 1 in the variable 'Boolean' if firing the transition succeeded, and 0 if it did not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = Fire( Object, Input )
      Exception = 'E_NONE';
      if iscell( Input )
        Name = Input{1};
        MyBinding = cell(size(Input,1)-1,1);
        for i = 2:size(Input,1)
          MyBinding{i-1} = Input{i};
        end
      else
        Name = Input;
        MyBinding = {};
      end
      if Object.HasConcession( Input )
        Boolean = 1;
        TransIdx = Object.RetrieveIndex( 'Transition', Name );
        for i = 1:size( Object.Places, 1)
          ThisEffect = Object.Arcs_Effect{i,TransIdx};
          [Bool,EffVar] = Object.ResolveBinding( MyBinding, Object.Arcs_Effect_Variables{i,TransIdx} );
          if Bool && ~isempty(EffVar)
            ThisEffect = ThisEffect + EffVar;
          end
          for j = 1:size( ThisEffect, 1 )
            Object.Current(j,i) = Object.Current(j,i) + ThisEffect(j);
          end
        end
      else
        Boolean = 0;
      end
      if ishandle( Object.Handle )
        Object.ViewImage;
      end
    end
    
    %% SetInitial
    %>Sets the initial marking for a single place
    %> - Replaces the current initial marking with the newly provided one.
    %>
    %> ### Input Signatures
    %>> PN.SetInitial(Object,\<PlaceID\>,{\<Marking_1\>;...;\<Marking_n\>})
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.SetInitial()
    %> - Stores the value 1 in the variable 'Boolean' if the initial marking is succesfully altered, and 0 if it is not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = SetInitial( Object, Place, NewInitials )
      Boolean = 1;
      Exception = 'E_NONE';
      if ~strcmp( Object.GetType( Place ), 'Place' )
        Boolean = 0;
        Object.CreateMessage( 'Exception Handling',{'Function: SetInitial';'Exception: E_TYPE'},'Error');
        Exception = 'E_TYPE';
      end
      PlaceIdx = Object.RetrieveIndex( 'Place', Place );
      ColSet = Object.Places{PlaceIdx,2};
      % Check whether an initial marking has been provided
      if size(NewInitials,1)
        ThisInitialMarking = NewInitials;
      else
        ThisInitialMarking = {};
      end
      % Generate a debug message to show the various parameters
%      Object.CreateMessage('State Info',{'Function: Add';'Status: Add Place';['Name: ',Name];['ColorSet: ',ThisColorSet];['InitialMarking: ',int2str(size(ThisInitialMarking,2))]},'Debug');
      % If everything is valid, check whether the provided initial marking is a valid marking for this place
      for i = 1:size(ThisInitialMarking,1)
        if Boolean
          % Parse the expression part
          ThisEntity = Object.ParseExpressionPart(ThisInitialMarking{i,1});
          if ~isempty( strmatch( ThisEntity, '' ) )
            % If no entity found, generate a message
            Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_MARKING';'Message: Color not found'},'Error');
            Exception = 'E_MARKING';
            Boolean = 0;
          else
            % Check whether the found entity is an element of the colorset
            if ~Object.InColorSet(ThisEntity,ColSet)
              Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_MARKING';['Message: Color ',ThisEntity,' does not appear in ',ColSet]},'Error');
              Exception = 'E_MARKING';
              Boolean = 0;
            end
          end
        end
      end
      % If everything is still valid, add the place to the set of Places matrix
      if Boolean
        for i=1:size(ThisInitialMarking,1)
          [ThisEntity,ThisValue] = Object.ParseExpressionPart(ThisInitialMarking{i,1});
          ThisIdx = Object.RetrieveIndex( 'Color', ThisEntity );
          Object.Initial(ThisIdx,PlaceIdx) = ThisValue;
        end
        Object.CreateMessage('Exception Handling',{'Function: Add';'Exception: E_NONE'},'Debug');
        Exception = 'E_NONE';
      end
      Object.Update;
    end
    
    %% SetInscription
    %>Sets the inscription of an arc
    %> - Replaces the current inscription with the newly provided one.
    %>
    %> ### Input Signatures
    %>> PN.SetInscription(Object,\<Arc\>,{\<Inscription_1\>;...;\<Inscription_n\>})
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.SetInscription()
    %> - Stores the value 1 in the variable 'Boolean' if the inscription is succesfully altered, and 0 if it is not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] =  SetInscription( Object, Arc, Inscription )
      Boolean = 1;
      [Type,Src,Dst] = Object.ParseArc( Arc );
      PlaceIdx = 0;
      TransIdx = 0;
      SrcType = Object.GetType( Src );
      DstType = Object.GetType( Dst );
      if ~isempty( strmatch( SrcType, 'Place' ) ) && ~isempty( strmatch( DstType, 'Transition' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Src );
        TransIdx = Object.RetrieveIndex( 'Transition', Dst );
      elseif ~isempty( strmatch( SrcType, 'Transition' ) ) && ~isempty( strmatch( DstType, 'Place' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Dst );
        TransIdx = Object.RetrieveIndex( 'Transition', Src );
      end
      if ~PlaceIdx || ~TransIdx
        Boolean = 0;
      end
      ThisColorSet = Object.Places{PlaceIdx,2};
      if isempty( strmatch( Type, 'Range' ) )
        for i = 1:size( Inscription,2 )
          if Boolean
            [Entity,Value,Exception] = Object.ParseExpressionPart( Inscription{i} );
            if isempty( strmatch( Exception, 'E_NONE' ) )
              Boolean = 0;
              Object.CreateMessage('Exception Handling',{'Function Add';'Exception: E_EXPR'},'Error');
            elseif Value < 0
              Boolean = 0;
              Object.CreateMessage('Exception Handling',{'Function Add';'Exception: E_VAL'},'Error');
            else
              if strcmp( Object.GetType( Entity ), 'Color' )
                if ~Object.InColorSet( Entity, ThisColorSet )
                  Object.CreateMessage( 'Exception Handling',{'Function: Add';'Exception: E_COLSET'},'Error');
                  Boolean = 0;
                end
              elseif strcmp( Object.GetType( Entity ), 'Variable' )
                VarIdx = Object.RetrieveIndex( 'Variable', Entity );
                if ~strcmp( ThisColorSet, Object.Variables{VarIdx,2} )
                  Object.CreateMessage( 'Exception Handling',{'Function: Add';'Exception: E_COLSET'},'Error');
                  Boolean = 0;
                end
              else
                Object.CreateMessage( 'Exception Handling',{'Function: Add';'Exception: E_TYPE'},'Error');
                Boolean = 0;
              end
            end
          end
        end
      end
      if Boolean
        Object.Update;
        CurrentLower = Object.Arcs_Lower{PlaceIdx,TransIdx};
        CurrentUpper = Object.Arcs_Upper{PlaceIdx,TransIdx};
        CurrentEffect = Object.Arcs_Effect{PlaceIdx,TransIdx};
        CurrentVarLower = Object.Arcs_Lower_Variables{PlaceIdx,TransIdx};
        CurrentVarUpper = Object.Arcs_Upper_Variables{PlaceIdx,TransIdx};
        CurrentVarEffect = Object.Arcs_Effect_Variables{PlaceIdx,TransIdx};
        switch Type
          case 'Inhibit'
            for i = 1:size( Inscription, 2 )
              [Entity,Value] = Object.ParseExpressionPart( Inscription{i} );
              if strcmp( Object.GetType( Entity ), 'Color' )
                EntityIdx = Object.RetrieveIndex( 'Color', Entity );
                CurrentUpper(EntityIdx) = min( CurrentUpper( EntityIdx ), Value-1 );
              else
                EntityIdx = Object.RetrieveIndex( 'Variable', Entity );
                CurrentVarUpper(EntityIdx) = min( CurrentVarUpper( EntityIdx ), Value-1 );
              end
            end
          case 'Read'
            for i = 1:size( Inscription, 2 )
              [Entity,Value] = Object.ParseExpressionPart( Inscription{i} );
              if strcmp( Object.GetType( Entity ), 'Color' )
                EntityIdx = Object.RetrieveIndex( 'Color', Entity );
                CurrentLower(EntityIdx) = CurrentLower( EntityIdx ) + Value;
              else
                EntityIdx = Object.RetrieveIndex( 'Variable', Entity );
                CurrentVarLower(EntityIdx) = CurrentVarLower( EntityIdx ) + Value;
              end
            end
          case 'Regular'
            for i = 1:size( Inscription, 2 )
              [Entity,Value] = Object.ParseExpressionPart( Inscription{i,1} );
              if strcmp( Object.GetType( Entity ), 'Color' )
                EntityIdx = Object.RetrieveIndex( 'Color', Entity );
                if strcmp( SrcType, 'Place' );
                  CurrentLower(EntityIdx) = CurrentLower(EntityIdx) + Value;
                  CurrentEffect(EntityIdx) = CurrentEffect(EntityIdx) - Value;
                else
                  CurrentEffect(EntityIdx) = CurrentEffect(EntityIdx) + Value;
                end
              else
                EntityIdx = Object.RetrieveIndex( 'Variable', Entity );
                if strcmp( SrcType, 'Place' );
                  CurrentVarLower(EntityIdx) = CurrentVarLower(EntityIdx) + Value;
                  CurrentVarEffect(EntityIdx) = CurrentVarEffect(EntityIdx) - Value;
                else
                  CurrentVarEffect(EntityIdx) = CurrentVarEffect(EntityIdx) + Value;
                end
              end
            end
        end
        Object.Arcs_Lower{PlaceIdx,TransIdx} = CurrentLower;
        Object.Arcs_Upper{PlaceIdx,TransIdx} = CurrentUpper;
        Object.Arcs_Effect{PlaceIdx,TransIdx} = CurrentEffect;
        Object.Arcs_Lower_Variables{PlaceIdx,TransIdx} = CurrentVarLower;
        Object.Arcs_Upper_Variables{PlaceIdx,TransIdx} = CurrentVarUpper;
        Object.Arcs_Effect_Variables{PlaceIdx,TransIdx} = CurrentVarEffect;
      end
      Object.Update;
    end
    
    %% SetEffect
    %>Sets the effect of a range arc
    %> - Replaces the current effect matrix with the newly provided one.
    %>
    %> ### Input Signatures
    %>> PN.SetEffect(Object,\<Arc\>,{\<Effect_c1\>;...;\<Effect_cn\>},{\<Effect_v1\>;...;\<Effect_vm\>})
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.SetEffect()
    %> - Stores the value 1 in the variable 'Boolean' if the effect is succesfully altered, and 0 if it is not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = SetEffect( Object, Arc, Effect, VarEffect )
      Exception = 'E_NONE';
      Boolean = 1;
      [~,Src,Dst] = Object.ParseArc( Arc );
      PlaceIdx = 0;
      TransIdx = 0;
      if ~isempty( strmatch( SrcType, 'Place' ) ) && ~isempty( strmatch( DstType, 'Transition' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Src );
        TransIdx = Object.RetrieveIndex( 'Transition', Dst );
      elseif ~isempty( strmatch( SrcType, 'Transition' ) ) && ~isempty( strmatch( DstType, 'Place' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Dst );
        TransIdx = Object.RetrieveIndex( 'Transition', Src );
      end
      if ~PlaceIdx || ~TransIdx
        Boolean = 0;
      end
      if Boolean
        Object.Arcs_Effect{PlaceIdx,TransIdx} = Effect;
        if nargin > 3
          Object.Arcs_Effect_Variables{PlaceIdx,TransIdx} = VarEffect;
        end
      end
    end
    
    %% SetLower
    %>Sets the Lower Bound of a range arc
    %> - Replaces the current Lower Bound matrix with the newly provided one.
    %>
    %> ### Input Signatures
    %>> PN.SetEffect(Object,\<Arc\>,{\<LowerBound_c1\>;...;\<LowerBound_cn\>},{\<LowerBound_v1\>;...;\<LowerBound_vm\>})
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.SetLower()
    %> - Stores the value 1 in the variable 'Boolean' if the Lower Bound is succesfully altered, and 0 if it is not.
    %> - Stores the last active exception in the variable 'Exception'.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = SetLower( Object, Arc, Lower, VarLower )
      Exception = 'E_NONE';
      Boolean = 1;
      [~,Src,Dst] = Object.ParseArc( Arc );
      PlaceIdx = 0;
      TransIdx = 0;
      if ~isempty( strmatch( SrcType, 'Place' ) ) && ~isempty( strmatch( DstType, 'Transition' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Src );
        TransIdx = Object.RetrieveIndex( 'Transition', Dst );
      elseif ~isempty( strmatch( SrcType, 'Transition' ) ) && ~isempty( strmatch( DstType, 'Place' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Dst );
        TransIdx = Object.RetrieveIndex( 'Transition', Src );
      end
      if ~PlaceIdx || ~TransIdx
        Boolean = 0;
      end
      if Boolean
        Object.Arcs_Lower{PlaceIdx,TransIdx} = Lower;
        if nargin > 3
          Object.Arcs_Lower_Variables{PlaceIdx,TransIdx} = VarLower;
        end
      end
    end
   
    %% SetUpper
    %>Sets the Upper Bound of a range arc.
    %> ### Input Signatures
    %>> PN.SetEffect(Object,\<Arc\>,{\<UpperBound_c1\>;...;\<UpperBound_cn\>},{\<UpperBound_v1\>;...;\<UpperBound_vm\>})
    %> - Replaces the current UpperBound matrix with the newly provided one.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.SetUpper()
    %> - Boolean stores the value 1 if the Upper Bound is succesfully altered, and 0 if it is not.
    %> - Exception stores the last active exception.
    %>
    %>\todo Exception Handling documenten
    function [Boolean,Exception] = SetUpper( Object, Arc, Upper, VarUpper )
      Exception = 'E_NONE';
      Boolean = 1;
      [~,Src,Dst] = Object.ParseArc( Arc );
      PlaceIdx = 0;
      TransIdx = 0;
      if ~isempty( strmatch( SrcType, 'Place' ) ) && ~isempty( strmatch( DstType, 'Transition' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Src );
        TransIdx = Object.RetrieveIndex( 'Transition', Dst );
      elseif ~isempty( strmatch( SrcType, 'Transition' ) ) && ~isempty( strmatch( DstType, 'Place' ) )
        PlaceIdx = Object.RetrieveIndex( 'Place', Dst );
        TransIdx = Object.RetrieveIndex( 'Transition', Src );
      end
      if ~PlaceIdx || ~TransIdx
        Boolean = 0;
      end
      if Boolean
        Object.Arcs_Upper{PlaceIdx,TransIdx} = Upper;
        if nargin > 3
          Object.Arcs_Upper_Variables{PlaceIdx,TransIdx} = VarUpper;
        end
      end
    end
    
    %% Remove
    %> Removes an element from the net.
    %>
    %> ### Input Signatures
    %>> PN.Remove( \<Identifier\> )
    %> - Removes the object that is identified by \<Identifier\> from the net.
    %>
    %> ### Output Signature
    %>> [Boolean,Exception] = PN.Remove()
    %> - Boolean stores whether the item has succesfully been removed.
    %> - Exception stores the last active exception state.
    function [Boolean,Exception] = Remove( Object, Identifier )
      Exception = 'E_NONE';
      Boolean = 1;
      IdentifierType = Object.GetType( Identifier );
      switch IdentifierType
        case 'Place'
          IdentifierIndex = Object.RetrieveIndex( 'Place', Identifier );
          Object.Arcs_Effect = PN.RemoveFromMatrix( Object.Arcs_Effect, 1, IdentifierIndex );
          Object.Arcs_Lower = PN.RemoveFromMatrix( Object.Arcs_Lower, 1, IdentifierIndex );
          Object.Arcs_Upper = PN.RemoveFromMatrix( Object.Arcs_Upper, 1, IdentifierIndex );
          Object.Arcs_Effect_Variables = PN.RemoveFromMatrix( Object.Arcs_Effect_Variables, 1, IdentifierIndex );
          Object.Arcs_Lower_Variables = PN.RemoveFromMatrix( Object.Arcs_Lower_Variables, 1, IdentifierIndex );
          Object.Arcs_Upper_Variables = PN.RemoveFromMatrix( Object.Arcs_Upper_Variables, 1, IdentifierIndex );
          Object.Initial = PN.RemoveFromMatrix( Object.Initial, 2, IdentifierIndex );
          Object.Current = PN.RemoveFromMatrix( Object.Current, 2, IdentifierIndex );
          Object.Places = PN.RemoveFromMatrix( Object.Places, 1, IdentifierIndex );
        case 'ColorSet'
          IdentifierIndex = Object.RetrieveIndex( 'ColorSet', Identifier );
          for i = 2:size( Object.ColorSets, 2 )
            ThisCol = Object.ColorSets{IdentifierIndex,i};
            if isempty(ThisCol)
              continue;
            end
            ColIdx = Object.RetrieveIndex( 'Color', ThisCol );
            for j = 1:size(Object.Places,1)
              for k = 1:size(Object.Transitions,1)
                Object.Arcs_Effect{j,k} = PN.RemoveFromMatrix( Object.Arcs_Effect{j,k}, 1, ColIdx );
                Object.Arcs_Lower{j,k} = PN.RemoveFromMatrix( Object.Arcs_Lower{j,k}, 1, ColIdx );
                Object.Arcs_Upper{j,k} = PN.RemoveFromMatrix( Object.Arcs_Upper{j,k}, 1, ColIdx );
              end
            end
            Object.Initial = PN.RemoveFromMatrix( Object.Initial, 1, ColIdx );
            Object.Current = PN.RemoveFromMatrix( Object.Current, 1, ColIdx );
            Object.Colors = PN.RemoveFromMatrix( Object.Colors, 1, ColIdx );
          end
          Object.ColorSets = PN.RemoveFromMatrix( Object.ColorSets, 1, IdentifierIndex );
        case 'Variable'
          IdentifierIndex = Object.RetrieveIndex( 'Variable', Identifier );
          for i = 1:size(Object.Places,1)
            for j = 1:size(Object.Transitions,1)
              Object.Arcs_Effect_Variables{i,j} = PN.RemoveFromMatrix( Object.Arcs_Effect_Variables{i,j}, 1, IdentifierIndex );
              Object.Arcs_Lower_Variables{i,j} = PN.RemoveFromMatrix( Object.Arcs_Lower_Variables{i,j}, 1, IdentifierIndex );
              Object.Arcs_Upper_Variables{i,j} = PN.RemoveFromMatrix( Object.Arcs_Upper_Variables{i,j}, 1, IdentifierIndex );
            end
          end
          Object.Variables = PN.RemoveFromMatrix( Object.Variables, 1, IdentifierIndex );
        case 'Transition'
          IdentifierIndex = Object.RetrieveIndex( 'Transition', Identifier );
          Object.Arcs_Effect = PN.RemoveFromMatrix( Object.Arcs_Effect, 2, IdentifierIndex );
          Object.Arcs_Lower = PN.RemoveFromMatrix( Object.Arcs_Lower, 2, IdentifierIndex );
          Object.Arcs_Upper = PN.RemoveFromMatrix( Object.Arcs_Upper, 2, IdentifierIndex );
          Object.Arcs_Effect_Variables = PN.RemoveFromMatrix( Object.Arcs_Effect_Variables, 2, IdentifierIndex );
          Object.Arcs_Lower_Variables = PN.RemoveFromMatrix( Object.Arcs_Lower_Variables, 2, IdentifierIndex );
          Object.Arcs_Upper_Variables = PN.RemoveFromMatrix( Object.Arcs_Upper_Variables, 2, IdentifierIndex );
          Object.Transitions = PN.RemoveFromMatrix( Object.Transitions, 1, IdentifierIndex );
        otherwise
          Exception = 'E_ID';
          Boolean = 0;
      end
      Object.Update
    end
    
    %% ViewImage
    %> Displays an image of the net in a Figure environment.
    %>
    %> ### Input Signatures
    %>> PN.ViewImage( )
    %> - Generates an image of the net through use of the 'dot' tool, that is provided by graphviz.
    %> - Requires Graphviz to be installed
    %>
    %> ### Output Signature
    %>> PN.ViewImage()
    %> - No return values.
    function ViewImage( Object )
      system( ['echo "', strrep(Object.GenerateDotDescription, '"', '\"'), '" | dot -Tpng -oTemp.png'] );
      Object.Handle = image( imread( 'Temp.png' ) );
    end
  end
end

