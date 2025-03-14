cask "tadabor" do
    version "2.6.0"
    
    # SHA256 for ARM and Intel versions
    sha256 arm: "aa3de07efa30508b1c849da6aa1f3b5f589ff06f10fdc2531b412cd93a2270cc", # ARM version
           intel: "e3a693f9b2ebc8f1ce61e76f167e1c8093f49b67a5c8721c5b1570c3a16f9c53" # Intel version
    
    # Define the URL based on architecture
    if Hardware::CPU.arm?
      url "https://github.com/mohammed-ashrf/MediSync_Release/releases/download/V2/Tadabor_2.6.0_aarch64.dmg"
    else
      url "https://github.com/mohammed-ashrf/MediSync_Release/releases/download/V2/Tadabor_2.6.0_x64.dmg"
    end
  
    name "Tadabor"
    homepage "https://tadabor.vercel.app"
    desc "A comprehensive study companion designed for meaningful engagement by Mohammed Younis"
  
    # Preflight: Ensure the app is not already installed
    preflight do
      if File.exist?("/Applications/Tadabor.app")
        raise "Error: Tadabor.app is already installed in /Applications. Please uninstall it first or use --force to overwrite."
      end
    end
  
    # Install the app
    app "Tadabor.app"
  
    # Post-install: Remove quarantine flag and handle errors
    postflight do
      begin
        system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", "#{appdir}/Tadabor.app"]
      rescue StandardError => e
        raise "Error: Failed to remove quarantine flag from Tadabor.app. Please try manually running 'xattr -d com.apple.quarantine #{appdir}/Tadabor.app'."
      end
    end
  
    # Trash files during uninstall
    zap trash: [
      "~/Library/Application Support/Tadabor",
      "~/Library/Preferences/com.Tadabor.plist"
    ]
  
    # After app install, verify successful installation
    uninstall_postflight do
      unless File.exist?("#{appdir}/Tadabor.app")
        raise "Error: Tadabor.app was not found after installation. Installation might have failed."
      end
    end
end  