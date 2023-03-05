Pwandzil’s dotfiles

# Installation
Unlike the tru lazy prgrammer would do - no installation currently available - just copy with your bare hands.

# Sections
This setup instructions will come for Windows (forgive me Steve), and also a few for MacOsX (thank you), and journey with Linux is WIP.

## Vim
~ U shall not know other editors than me.
The only real choices are Vim and Em.. Vim. 
Cant wait to port my Cygwin setup to Arch or WSL.

## Terminal 
Everyone on knows those programmers with visual editors, sometimes you just don't even have energy to ask.. how do they run it via terminal?
Yeah. They don't right?

### Tmux 
Once you got a terminal you would also like a multiplexer right? 
Like with Vim the real challange is which set of shortcuts to use! Ha!
But the first shock comes, when we discover Tmux comes with EMACS shortcuts by default (you have betrayed me!)

### TerminalEmulators 

#### MacOs iTerm2
This was helpful: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/

#### Windows: Cmd.exe vs ConEmu vs cmder
I really like Cmd.exe but sometimes I switch to cmder to try something different.

## Git
Use use use the golden shortucs of git. They will ease you life or at least make u look cool in the eyes of the bystanders.

## VSCode via Github Gist (Gist Id + Github AccessToken)
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
