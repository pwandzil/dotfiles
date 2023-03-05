Pwandzil’s dotfiles

# Installation
Unlike the tru lazy prgrammer would do - no installation currently available - just copy with your bare hands.

# Sections
This setup instructions will come for Windows (forgive me Steve), and also a few for MacOsX (thank you), and journey with Linux is WIP.

## Unix Shell
### Zsh
Right.

### SSH and its config
Ok so now we know we will use asymetric public key cryptography. https://en.wikipedia.org/wiki/Secure_Shell

It would be nice to also have a config so we can manage:
- different keys for different sites
- govern registration with ssh-agent & keychain if needed

For github it seems its not really trivial to use 2 keys ? https://gist.github.com/jexchan/2351996

    # Each time, I have to check ssh-add -l to delete unneeded keys and reserve the key needed.
    # For example, if I need id_rsa_id2, then I will do the below:
    ssh-add -d ~/.ssh/id_rsa_id1
    ssh-add -K ~/.ssh/id_rsa_id2


## Computer Terminal
### VT100
Remember DEC VT100? Me neither. 

### TerminalEmulators
No longer VT100, so modern computers now have emulators. Meh. 
Everyone on knows those programmers with grahical editors, sometimes you just don't even have energy to ask.. how do they run it remotely?
Yeah. They don't right? Or they use some "extensions" additional software that a real programmer just do not need. 

#### Tmux 
Once you got a terminal you would also like a multiplexer right? 
Like with Vim the real challange is which set of shortcuts to use! Ha!
But the first shock comes, when we discover Tmux comes with EMACS shortcuts by default (you have betrayed me!)

#### MacOs iTerm2
This was helpful: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/

#### Windows: Cmd.exe vs ConEmu vs cmder
I really like Cmd.exe but sometimes I switch to cmder to try something different.

## Git
Use use use the golden shortucs of git. They will ease you life or at least make u look cool in the eyes of the bystanders.

## Editors 
### Vim
~ U shall not know other editors than me.
The only real choices are Vim and Em.. Vim. 
Cant wait to port my Cygwin setup to Arch or WSL.

### VSCode via Github Gist (Gist Id + Github AccessToken)
Just use the golden "Settings Sync" extensions for that you need to:
1. Install VSCode
2. Install extension "Settings Sync"
3. Login to github and Generate Access Token with "Create Gist" permission (!watch out, ?nonpro? github allows to generate tokens valid for atmost 1 year)
4. Press: \<Ctr/Cmd\> + \<Shift\> + \<P\>: \
   Choose: Sync: Advanced Options \
   Press \<Enter\> \
   Choose: Open Settings -> for Github Gist ID &  for Github Token (Password/Key)
    (Stored at Choose: Edit Extension Local Settings  -> C:/Users/\<user\>/AppData/Roaming/Code/User/syncLocalSettings.json)
5. Then u can upload and download with \<Ctr/Cmd\> + \<Shift\> + \<P\>: "Sync" commands

## VSCode via Native Sync
I dunno.
