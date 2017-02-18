//PotatoShell.hpp
#ifndef POTATOSHELL_H
#define POTATOSHELL_H


#include <string>

class PotatoShell
{
    public:
        PotatoShell();
        PotatoShell(const PotatoShell& copy);
        PotatoShell& operator=(const PotatoShell& copy);
        ~PotatoShell();
        
        std::string prompt();
        pid_t spawn(const std::string& cmd);
        void monitor(pid_t pid);

        void setDone(){done = true;};
        bool getDone(){return done;};
    private:
        bool done = false;
	
};

#endif
