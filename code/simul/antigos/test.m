t = 0 : 0.01 : 2 * pi;
r = abs( 2 + 5 * sin( 3 .* t ) .* ( 1 + 2 * pi .* t - t .^ 2 ) );
p = polar( gca, t, r );

% set( groot, 'showhiddenhandles', 'on' )
% TTicks = [ 0  : 30 : 359 ];  % Note: here, specified in degrees
RTicks = [ 20 : 20 : 100 ];  % Note: 'zero' not included!
% set( gca, 'ttick', TTicks );
set( gca, 'rtick', RTicks );

% NumTticks = length( TTicks );
NumRticks = length( RTicks );   % will only be correct if zero was excluded above.

PolarGrid = findobj( gca, 'tag', 'polar_grid' );
Handles = get( PolarGrid, 'children' );
NumHandles = length( Handles );

legend('show')

% The children are arranged as follows:
%   NumTticks handles: text objects that make up the ttick labels (from last to first)
%   NumTticks handles: line objects that make up the ttick gridlines
%   NumRticks handles: text objects that make up the rtick labels (from last to first)
%   NumRticks handles: line objects that make up the rtick concentric gridlines
%   Last handle      : A darker line, coinciding with the last rtick gridline, serving as the outline.

% Therefore, to change the rticklabels:
% RTickLabelHandles = Handles( NumHandles - NumRticks - [1 : NumRticks] );
% RTickLabels = { '', '30db', '20db', '10db', '0' };
% for i = 1 : NumRticks, set( RTickLabelHandles(i), 'string', RTickLabels{i} ), end;
