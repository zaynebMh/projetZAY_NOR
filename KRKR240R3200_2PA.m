% Définition des symboles pour les paramètres DH
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

% === Matrice de transformation totale du robot ===
T05 = simplify(T01 * T12 * T23 * T34 * T45);

% === Définir des valeurs numériques pour les paramètres DH ===
q1 = 0; q2 = 0; q3 = 0; q4 = 0; q5 = 0; % Angles articulaires
d1 = 645; d2 = 0; d3 = 1350; d4 = 0; d5 = -250; % Longueurs
a1 = 0; a2 = 330; a3 = 0; a4 = 1255; a5 = 265;  % Longueurs des liens
alpha1 = 0; alpha2 = 0; alpha3 = 0; alpha4 = 0; alpha5 = 0; % Angles DH

% Substitution des valeurs numériques dans chaque matrice de transformation
T01num = double(subs(T01));
T12num = double(subs(T12));
T23num = double(subs(T23));
T34num = double(subs(T34));
T45num = double(subs(T45));
T05num = double(subs(T05));

% Affichage des matrices résultantes
disp('Matrice de transformation totale T05 :');
disp(T05num);

% Position finale de l'effecteur
position_finale = T05num(1:3, 4);
disp('Position finale du robot :');
disp(position_finale);

% === Visualisation 3D du robot ===
% Positions des points (base + extrémités des liens)
P0 = [0; 0; 0]; % Position initiale
P1 = T01num(1:3, 4);

% Calcul intermédiaire pour chaque transformation successive
T02num = T01num * T12num;
P2 = T02num(1:3, 4);

T03num = T02num * T23num;
P3 = T03num(1:3, 4);

T04num = T03num * T34num;
P4 = T04num(1:3, 4);

T05num = T04num * T45num;
P5 = T05num(1:3, 4);

% Conversion en matrice pour tracé
positions = [P0, P1, P2, P3, P4, P5];

% Création de la figure
figure;
plot3(positions(1, :), positions(2, :), positions(3, :), 'o-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
hold on;

% Ajouter des axes et des labels
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
title('Robot Articulé 3D');
axis equal;
legend('Liens du robot');

% Affichage des liens et des axes
for i = 1:size(positions, 2)-1
    plot3([positions(1, i), positions(1, i+1)], ...
          [positions(2, i), positions(2, i+1)], ...
          [positions(3, i), positions(3, i+1)], 'r-', 'LineWidth', 2);
end

hold off;
