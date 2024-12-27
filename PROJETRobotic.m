% === Définition des symboles pour les paramètres DH ===
syms thetai di ai alphai

% Matrice de transformation homogène générale selon les paramètres DH
T = [cos(thetai), -sin(thetai)*cos(alphai),  sin(thetai)*sin(alphai), ai*cos(thetai);
     sin(thetai),  cos(thetai)*cos(alphai), -cos(thetai)*sin(alphai), ai*sin(thetai);
              0,             sin(alphai),             cos(alphai),            di;
              0,                      0,                      0,              1];

% === Définir les transformations homogènes pour chaque articulation ===
% Transformation de la base vers le premier lien
syms q1 d1 a1 alpha1
thetai = q1; di = d1; ai = a1; alphai = alpha1;
T01 = subs(T);

% Transformation du premier lien au deuxième lien
syms q2 d2 a2 alpha2
thetai = q2; di = d2; ai = a2; alphai = alpha2;
T12 = subs(T);

% Transformation du deuxième lien au troisième lien
syms q3 d3 a3 alpha3
thetai = q3; di = d3; ai = a3; alphai = alpha3;
T23 = subs(T);

% Transformation du troisième lien au quatrième lien
syms q4 d4 a4 alpha4
thetai = q4; di = d4; ai = a4; alphai = alpha4;
T34 = subs(T);

% Transformation du quatrième lien au cinquième lien
syms q5 d5 a5 alpha5
thetai = q5; di = d5; ai = a5; alphai = alpha5;
T45 = subs(T);

% === Animation du robot ===
% Plage de mouvements pour les angles articulaires
angles_q1 = linspace(0, pi/2, 100); %  Rotation de 0 à pi/2 pour q1
angles_q2 = linspace(0, pi/4, 100); %  Rotation de 0 à pi/4 pour q2
angles_q3 = linspace(0, -pi/6, 100); %  Rotation de 0 à -pi/6 pour q3
angles_q4 = linspace(0, pi/3, 100); %  Rotation de 0 à pi/3 pour q4
angles_q5 = linspace(0, -pi/2, 100); %  Rotation de 0 à -pi/2 pour q5

% Paramètres DH fixes
d1 = 645; d2 = 0; d3 = 1350; d4 = 0; d5 = -250; % Longueurs
a1 = 0; a2 = 330; a3 = 0; a4 = 1255; a5 = 265;  % Longueurs des liens
alpha1 = 0; alpha2 = 0; alpha3 = 0; alpha4 = 0; alpha5 = 0; % Angles DH


angles_rotation = linspace(0, 2*pi, 100); % Rotation de 0 à 360° autour de Z
figure;
grid on;
hold on;

% les référence des axes
plot3([-2000, 2000], [0, 0], [0, 0], 'k--', 'LineWidth', 1); % Axe X
plot3([0, 0], [-2000, 2000], [0, 0], 'k--', 'LineWidth', 1); % Axe Y
plot3([0, 0], [0, 0], [0, 2000], 'k-', 'LineWidth', 2);     % Axe Z

% les noms des axes
text(2000, 0, 0, 'X', 'FontSize', 12, 'Color', 'r');
text(0, 2000, 0, 'Y', 'FontSize', 12, 'Color', 'g');
text(0, 0, 2000, 'Z', 'FontSize', 12, 'Color', 'b');

xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
title('Animation du Robot avec Rotation Globale autour de Z');
axis equal;

% Limites des axes
xlim([-2000, 2000]);
ylim([-2000, 2000]);
zlim([0, 2000]);
view(3);  

% l''animation
for k = 1:length(angles_rotation)
    theta_global = angles_rotation(k); % Angle de rotation globale
    Rz = [cos(theta_global), -sin(theta_global), 0;
          sin(theta_global),  cos(theta_global), 0;
          0,                 0,                 1]; % Matrice de rotation autour de Z

    q1 = angles_q1(k);
    q2 = angles_q2(k);
    q3 = angles_q3(k);
    q4 = angles_q4(k);
    q5 = angles_q5(k);

    T01num = double(subs(T01));
    T12num = double(subs(T12));
    T23num = double(subs(T23));
    T34num = double(subs(T34));
    T45num = double(subs(T45));
   
    P0 = [0; 0; 0]; 
    P1 = T01num(1:3, 4);
    T02num = T01num * T12num;
    P2 = T02num(1:3, 4);
    T03num = T02num * T23num;
    P3 = T03num(1:3, 4);
    T04num = T03num * T34num;
    P4 = T04num(1:3, 4);
    T05num = T04num * T45num;
    P5 = T05num(1:3, 4);
    
    % Appliquer la rotation globale à chaque position
    P0_rot = Rz * P0;
    P1_rot = Rz * P1;
    P2_rot = Rz * P2;
    P3_rot = Rz * P3;
    P4_rot = Rz * P4;
    P5_rot = Rz * P5;
    
    positions_rot = [P0_rot, P1_rot, P2_rot, P3_rot, P4_rot, P5_rot];
    
    cla; 
    plot3(positions_rot(1, :), positions_rot(2, :), positions_rot(3, :), 'o-', 'LineWidth', 2, 'MarkerSize', 8);

    for j = 1:size(positions_rot, 2)-1
        plot3([positions_rot(1, j), positions_rot(1, j+1)], ...
              [positions_rot(2, j), positions_rot(2, j+1)], ...
              [positions_rot(3, j), positions_rot(3, j+1)], 'r-', 'LineWidth', 2);
    end
   
    pause(0.05);
end

hold off;
