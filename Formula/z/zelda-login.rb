class ZeldaLogin < Formula
  desc "Play Zelda's secret sound when opening a new terminal window"
  homepage "https://github.com/quitequinn/ZeldaLogin"
  url "https://github.com/quitequinn/ZeldaLogin/archive/v2.1.0.tar.gz"
  sha256 "bc679cdbcd49dfa4f1e678b175798cbe3cde7f60d605cf823c266603998a70b6"
  license "MIT"
  head "https://github.com/quitequinn/ZeldaLogin.git", branch: "master"

  depends_on "curl"

  def install
    # Install the audio file to share directory
    (share/"zelda-login").install "zelda-secret.mp3"
    
    # Install the installer script
    bin.install "install.sh" => "zelda-login-install"
    
    # Install configuration examples
    (share/"zelda-login/configs").install Dir["configs/*"]
    
    # Install documentation
    (share/"doc/zelda-login").install "README.md", "PACKAGE_MANAGERS.md"
  end

  def caveats
    <<~EOS
      Zelda Login has been installed but not yet configured.

      To set up terminal audio:
        zelda-login-install

      To configure for specific shells:
        # Bash
        echo 'afplay #{share}/zelda-login/zelda-secret.mp3 > /dev/null 2>&1 &' >> ~/.bash_profile
        
        # Zsh  
        echo 'afplay #{share}/zelda-login/zelda-secret.mp3 > /dev/null 2>&1 &' >> ~/.zshrc

      See example configs in: #{share}/zelda-login/configs/

      To uninstall completely:
        1. Remove the audio command from your shell config
        2. brew uninstall zelda-login
    EOS
  end

  test do
    # Test that the audio file exists
    assert_predicate share/"zelda-login/zelda-secret.mp3", :exist?
    
    # Test that the installer script is executable
    assert_predicate bin/"zelda-login-install", :executable?
    
    # Test that we can run the installer with --version
    system bin/"zelda-login-install", "--version"
  end
end