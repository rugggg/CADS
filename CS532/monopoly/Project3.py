import numpy as np;
import matplotlib.pyplot as plt;
import matplotlib.animation as animation;

n = 40;
dice_size = 6;

def main():
        monopoly = np.zeros((n,n));

        base_row = np.concatenate((np.full(dice_size,1/dice_size),np.zeros(n-dice_size)));
        initial_position = np.zeros(n);
        initial_position[0] = 1;

        #creating transition matrix
        for i in range(40):
                temp = np.roll(base_row,i+1);
                monopoly[i,:] = temp;   
        monopoly = np.dot(monopoly,monopoly);

        #getting the probabilities (i.e. transition matrix)
        probabilities = run_simulation(monopoly, initial_position, 200);
        
        y = probabilities[0];
        x = np.linspace(0,n,len(y));
        
        fig, ax = plt.subplots();
        ax = plt.axes(xlim=(0,40),ylim=(0,0.1));
        line, = ax.plot(x,y,color='r');
        
        def init():
                line.set_data(x,y);
                return line,
        
        def animate(i):
                line.set_data(x,probabilities[i]);
                return line,
                
#        anim = animation.FuncAnimation(fig, animate, init_func=init, frames=100, interval=len(probabilities));
#        Writer = animation.writers['ffmpeg'];
#       Writer = Writer(fps=15,metadata=dict(artist='Me'),bitrate=1800);
#        anim.save('monopoly.mp4',writer=Writer);
        
#        plt.show();
        analyzeJailRR(probabilities)
        
        np.savetxt('probabilities.csv', monopoly, delimiter=',', fmt='%.2f');
                
def go_to_jail(board):
        board[:,10] += board[:,30];
        board[:,30] = 0;
        
def chance(board):
        chance_locations = [7,22,36];
        
        #picking a random location
        which_chance_location = np.random.choice(chance_locations);
        #picking a random chance card
        which_chance_card = np.random.randint(0,16);
        
        if (which_chance_card == 0):
                if (which_chance_location == chance_locations[0]):
                        board[:,12] += board[:,chance_locations[0]];
                        board[:,chance_locations[0]] = 0;
                elif (which_chance_location == chance_locations[1]):
                        board[:,28] += board[:,chance_locations[1]];
                        board[:,chance_locations[1]] = 0;
                elif (which_chance_location == chance_locations[2]):
                        board[:,12] += board[:,chance_locations[2]];
                        board[:,chance_locations[2]] = 0;
        elif (which_chance_card == 1):
                board[:,10] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 2):
                board[:,which_chance_location-3] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 3):
                #get out of jail free so nothing to do
                pass;
        elif (which_chance_card == 4):
                #make general repairs to all property
                pass;
        elif (which_chance_card == 5):
                #bank pays you dividend of $50
                pass;
        elif (which_chance_card == 6):
                #advance to go
                board[:,0] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 7 or which_chance_card == 11): #there are 2 nearest railroads
                #advance to nearest railroad
                if (which_chance_location == chance_locations[0]):
                        board[:,15] += board[:,chance_locations[0]];
                        board[:,chance_locations[0]] = 0;
                elif (which_chance_location == chance_locations[1]):
                        board[:,25] += board[:,chance_locations[1]];
                        board[:,chance_locations[1]] = 0;
                elif (which_chance_location == chance_locations[2]):
                        board[:,5] += board[:,chance_locations[2]];
                        board[:,chance_locations[2]] = 0;
        elif (which_chance_card == 8):
                board[:,24] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 9):
                board[:,11] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 10):
                board[:,5] += board[:,which_chance_location];
                board[:,which_chance_location] = 0;
        elif (which_chance_card == 12):
                #elected chairman of the board
                pass;
        elif (which_chance_card == 13):
                #advance to boardwalk
                board[:,39] += board[:,which_chance_location];
                # board[:,which_chance_location] = 0;
        elif (which_chance_card == 14):
                #speeding fine $15
                pass;
        elif (which_chance_card == 15):
                #building loan matures. collect $150
                pass;
        
def chest(board):
        chest_locations = [2,17,33];
        
        which_chest_location = np.random.choice(chest_locations);
        which_chest_card = np.random.randint(0,16);
        
        if (which_chest_card == 0):
                pass;
        elif (which_chest_card == 1):
                pass;
        elif (which_chest_card == 2):
                pass;
        elif (which_chest_card == 3):
                pass;
        elif (which_chest_card == 4):
                pass;
        elif (which_chest_card == 5):
                pass;
        elif (which_chest_card == 6):
                board[:,0] += board[:,which_chest_location];
                board[:,which_chest_location] = 0;
        elif (which_chest_card == 7):
                pass;
        elif (which_chest_card == 8):
                pass;
        elif (which_chest_card == 9):
                pass;
        elif (which_chest_card == 10):
                pass;
        elif (which_chest_card == 11):
                pass;
        elif (which_chest_card == 12):
                board[:,10] += board[:,which_chest_location];
                board[:,which_chest_location] = 0;
        elif (which_chest_card == 13):
                pass;
        elif (which_chest_card == 14):
                pass;
        elif (which_chest_card == 15):
                pass;
        
def run_simulation(board, initial_position, runs):
        res = initial_position;
        probabilities = [];
        
        go_to_jail(board);

        for i in range(runs):
                res = np.dot(res,board);
                probabilities.append(res);
                chance(board);
                chest(board);   
                
        return(probabilities);
        
def analyzeJailRR(probabilities):
        for i in range(len(probabilities)):
                print(probabilities[i][5],"  ",i)
                print(probabilities[i][15],"  ",i)
                print(probabilities[i][25],"  ",i)

if __name__ == '__main__':
        main();
