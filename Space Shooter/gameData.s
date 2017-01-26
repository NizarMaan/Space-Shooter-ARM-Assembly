.section .text

.globl GameData

GameData:
    bx      lr








.section .data
.align  4

.globl QueenDim, QueenMov, QueenSpeed, QueenDirection, QueenArray, KnightDim, KnightMov, KnightSpeed, KnightDirection, KnightArray, PawnDim, PawnMov, PawnSpeed, PawnDirection, PawnArray, PlayerDim, PlayerPos, Bullet, BulletDim, BulletPos, BulletMov, BulletPawn, BulletKnight, BulletQueen, ObstacleDim, ObstacleArray, GameState, PauseMenuPointer, Score

QueenDim:   .int    30
QueenMov:   .int    0
QueenSpeed: .int    5
QueenDirection: .int    0
QueenArray: .int    q1, q2             // the queens
q1:         .int    300, 50, 0, 0, 0, 5          // x-cor, y-cor, bullet, bullet-x-cor, bullet-y-cor, health
q2:         .int    620, 50, 0, 0, 0, 5

KnightDim:  .int    35
KnightMov:  .int    0
KnightSpeed: .int   3
KnightDirection: .int   0
KnightArray:.int    k1, k2, k3, k4, k5
k1:         .int    220, 100, 0, 0, 0, 3
k2:         .int    340, 100, 0, 0, 0, 3
k3:         .int    460, 100, 0, 0, 0, 3
k4:         .int    580, 100, 0, 0, 0, 3
k5:         .int    700, 100, 0, 0, 0, 3

PawnDim:    .int    45
PawnMov:    .int    0
PawnSpeed:  .int    1
PawnDirection: .int     0
PawnArray:  .int    p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 
p1:         .int    25, 200, 0, 0, 0, 1
p2:         .int    125, 200, 0, 0, 0, 0
p3:         .int    225, 200, 0, 0, 0, 0
p4:         .int    325, 200, 0, 0, 0, 0
p5:         .int    425, 200, 0, 0, 0, 0
p6:         .int    525, 200, 0, 0, 0, 0
p7:         .int    625, 200, 0, 0, 0, 0
p8:         .int    725, 200, 0, 0, 0, 0
p9:         .int    825, 200, 0, 0, 0, 0
p10:        .int    925, 200, 0, 0, 0, 0

PlayerDim:  .int    35
PlayerPos:  .int    450, 700

Bullet:     .int    0
BulletDim:  .int    5, 10
BulletPos:  .int    0, 0
BulletMov:  .int    10
BulletPawn: .int    3
BulletKnight: .int  5
BulletQueen: .int   7

ObstacleDim:      .int    100
ObstacleArray:    .int    o1, o2, o3  
o1:        .int    125, 575, 15             // x-cor, y-cor, height
o2:        .int    425, 575, 15
o3:        .int    725, 575, 15

GameState: .byte    2           // 0 = Pause, 1 = Game running, 2 = StartMenu, 3 = EndGameMenu

PauseMenuPointer:   .byte    0

Score:  .byte    '0','5', '0', '!'   
