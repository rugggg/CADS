// PotatoShell.cpp

#include "potato_shell.hpp"

#include <iostream>
#include <string>
#include <unistd.h>
#include <sys/time.h>
#include <sys/wait.h>

using namespace std;

PotatoShell::PotatoShell(){};
PotatoShell::~PotatoShell(){}

std::string PotatoShell::prompt(){
    cout << "\u2653\u2653\u077A ";
    std::string cmd;
    getline(cin,cmd);
    if(cmd == "exit"|| cmd == "Exit"){
            setDone();
    }
    return cmd;
};

pid_t PotatoShell::spawn(const std::string& cmd){
    pid_t pid = fork();
    if(pid == 0){
        execlp("/bin/sh","/bin/sh","-c",cmd.c_str(),(char*)NULL );
    }    
    else if(pid > 0){
        //special case to handle directory change
        if(cmd.find("cd") != string::npos){
                auto changeDir = cmd.substr(cmd.find(' ')+1,cmd.size());
                if(chdir(changeDir.c_str()) != 0){
                        if(errno == 1){
                            cout<<"Insuffcient Permission"<<endl;
                        }
                        else if(errno == 2){
                            cout<<"Directory does not exist"<<endl;
                        }
                        else{
                            cout<<"Cannot cd to "<<changeDir<<", is a file"<<endl;
                        }
                }
            }
        //hold parent until child finishes
        int status;
        while (-1 == waitpid(pid, &status, 0));
        if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
            //cerr << "Process  (pid " << pid << ") failed" << endl;
        }
        //parent 
    }
    else{
        cout << "failed" << std::endl;
    }
    return pid;
};
int main(){
    PotatoShell pShell;
    while(!pShell.getDone()){
            std::string cmd  = pShell.prompt();
            pShell.spawn(cmd);
    }
}


