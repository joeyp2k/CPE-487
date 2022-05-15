# Final Project: 4 Player Pong
For this project I decided to modify lab 6 to create a four player game of pong.  One paddle protects each edge of the screen and the paddles on opposite sides are teammates either increasing or decreasing the score count.  Four potentiometers are needed using the JA, JB, JC, and JD ports on the Nexys A7 in order to fully operate the game.  Since I only had access to one potentiometer when developing this project, I demonstrated the game if the ball were to bounce off of the magenta and yellow paddle since it would be impossible for me to remove and connect the potentiometer to the blue or cyan paddle while playing the game.

Some areas of improvement include updating the bat_n_ball module to position the ball in the center of the screen for serving and prevent the score counter from counting while both the ball isn't visible and a game isn't running.  When the ball isn't visible, there is still an entity moving throughout the screen that bounces off the edges and increments or decrements the score counter.

## Blue Bat
https://user-images.githubusercontent.com/65480784/168452253-0528c894-3f65-457e-9f57-5ef84a22f305.MP4


## Cyan Bat
https://user-images.githubusercontent.com/65480784/168452254-1b55fa64-3c7e-4a92-b059-4fb80e4c3594.MP4


## Magenta Bat
https://user-images.githubusercontent.com/65480784/168452255-070da00c-2221-48df-b283-f02a6f4da81f.MP4


## Yellow Bat
https://user-images.githubusercontent.com/65480784/168452258-60beeb49-8918-4ea0-8909-84b9102f0443.MP4


## Magenta Bounce
https://user-images.githubusercontent.com/65480784/168452264-5bf4bebf-028f-4799-a49a-9b40002a6520.MP4


## Yellow Bounce
https://user-images.githubusercontent.com/65480784/168452262-28d2877e-b0b4-4a6e-a866-8ccd99db0fa9.MP4

