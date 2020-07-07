push=require 'push'

Class=require 'class'
require 'Ball'
require 'Paddle'

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243

PADDLE_SPEED=200


function love.load()
     love.graphics.setDefaultFilter('nearest','nearest')
	 smallFont=love.graphics.newFont('font.ttf',8)
	 scoreFont=love.graphics.newFont('font.ttf',32)
	 BigFont=love.graphics.newFont('font.ttf',42)
	    -- love.graphics.setFont(smallFont)
		 
		 love.window .setTitle('pong')
	 
	  math.randomseed(os.time())
	  
	  sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
        }
	 
	  
	  push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
	     fullscreen=false,
		 resizable=true,
		 vsync=false
		 })
		 
	 
		 
	 player1score=0
     player2score=0
	 
	 servingplayer=1
	 
	 winningplayer=1
	 
	 player1=Paddle(10,30,5,20)
     player2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
	 ball=Ball(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2,5,5)
	 
	 gameState='start'
end

function love.resize(w,h)
     push:resize(w,h)
end

	 
function love.update(dt)

     if ball.y<=0 then
	      ball.y=0
		  ball.dy=-ball.dy
		  sounds['wall_hit']:play()
	 end
	 
	 if ball.y>=VIRTUAL_HEIGHT-5 then
	      ball.y=VIRTUAL_HEIGHT-5
		  ball.dy=-ball.dy
		   sounds['wall_hit']:play()
	 end
	 
     if love.keyboard.isDown('up') then 
	     player2.dy=-PADDLE_SPEED
		 
	 elseif love.keyboard.isDown('down') then
		 player2.dy=PADDLE_SPEED
		 
	else 
	      player2.dy=0
	end
	
    if ball.x<VIRTUAL_WIDTH/2 and ball.dx<0 then
		     if player1.y<ball.y then
			     player1.dy=PADDLE_SPEED
			 end
			 
			 if player1.y>ball.y then
			     player1.dy=-PADDLE_SPEED
			 end
			 
			 if player1.y==ball.y then
			     player1.dy=0
			 end
			 
	 end
             	
	if gameState=='play' then
     ball:update(dt)
	 
	     	 
     end
	 
 player1:update(dt)
 player2:update(dt)

if gameState=='play' then
	 
	    if ball:collides(player1) then
	         ball.dx=-ball.dx * 1.03
		     ball.x=ball.x+ 6
			 sounds['paddle_hit']:play()
		 
		 
		     if ball.dy<0 then
		         ball.dy=-math.random(10,150)
		     else
		          ball.dy=math.random(10,150)
		    end
	    end
		 
		if ball:collides(player2) then
	         ball.dx=-ball.dx*1.03
		     ball.x=player2.x-5
		     sounds['paddle_hit']:play()
		  
		     if ball.dy<0 then
		         ball.dy=-math.random(10,150)
		     else
		          ball.dy=math.random(10,150)
		     end
		end

    
	  if ball.x<0 then
	      servingplayer=1
	      player2score=player2score+1
		  sounds['score']:play()
		  
		    if player2score==5 then
			  winningplayer=2
			  gameState='done'
			 else
			 
		  ball:reset()
		  gameState='start'
		  end
		  end
		  
	  if ball.x>VIRTUAL_WIDTH then
	      servingplayer=2
          player1score=player1score+1
		  sounds['score']:play()
		  
		    if player1score==5 then
			  winningplayer=1
			  gameState='done'
			else
			 
          ball:reset()
		  gameState='start'
		  end
		  end
end		  

if gameState=='serve' then
 
      ball.dy=math.random(-50,50)
		  if servingplayer==1 then
		   ball.dx=200
		  
		 elseif servingplayer==2 then
		    ball.dx=-200
			end
			
    
end

if gameState=='done' then
     player1score=0
	 player2score=0
	 ball:reset()
	 end
	 
end

	
function love.keypressed(key)
	 if key =='escape' then
	     love.event.quit()
	 
	 
	elseif key =='enter'or key=='return' then
	      if gameState=='start' then
		      gameState='play'
		  else
 		       gameState='start'
			   
			   ball:reset()
		   end
	  end
end



function love.draw()
     push:apply('start')
    
	 love.graphics.clear(6/255,86/255,131 /255,1)
	 love.graphics.setFont(smallFont)
	 if gameState=='start' then
	 love.graphics.printf('PRESS ENTER TO START',0,20,VIRTUAL_WIDTH,'center')
	
	    
		 love.graphics.printf('PLAYER'..tostring(servingplayer)..' S TURN TO SERVE',0,10,VIRTUAL_WIDTH,'center')
		 
		
	  end
	  if gameState=='play' then
	 love.graphics.printf('PONG!',0,20,VIRTUAL_WIDTH,'center')
	  end
	  

      if gameState=='done' then
	     love.graphics.setFont(BigFont)
		 love.graphics.printf('PLAYER'..tostring(winningplayer)..'WINS',0,10,VIRTUAL_WIDTH,'center')
	   end
	   
	  love.graphics.setFont(scoreFont)
	  love.graphics.printf(tostring(player1score),0,60,VIRTUAL_WIDTH-50,'center')
	  love.graphics.printf(tostring(player2score),0,60,VIRTUAL_WIDTH+50,'center')
	  
	  player1:render()
	  player2:render()
	  
	  ball:render()
	  displayFPS()
	 push:apply('end')
end

function displayFPS()
love.graphics.setFont(smallFont)
love.graphics.setColor(1,0,0,1)
love.graphics.print('FPS: '..tostring(love.timer.getFPS()),10,10)
end
