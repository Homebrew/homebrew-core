class ZeldaLogin < Formula
  desc "Play Zelda's secret sound when opening a new terminal window"
  homepage "https://github.com/quitequinn/ZeldaLogin"
  url "https://github.com/quitequinn/ZeldaLogin.git", tag: "v2.1.0"
  sha256 "bc679cdbcd49dfa4f1e678b175798cbe3cde7f60d605cf823c266603998a70b6"
  license "MIT"
  head "https://github.com/quitequinn/ZeldaLogin.git", branch: "main"

  def install
    # Install the audio file to share directory
    pkgshare.install "zelda-secret.mp3"

    # Install the installer script
    bin.install "install.sh" => "zelda-login-install"

    # Install configuration examples
    (pkgshare/"configs").install Dir["configs/*"]

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
        echo 'afplay #{pkgshare}/zelda-secret.mp3 > /dev/null 2>&1 &' >> ~/.bash_profile

        # Zsh
        echo 'afplay #{pkgshare}/zelda-secret.mp3 > /dev/null 2>&1 &' >> ~/.zshrc

      See example configs in: #{pkgshare}/configs/

      To uninstall completely:
        1. Remove the audio command from your shell config
        2. brew uninstall zelda-login
    EOS
  end

  test do
    # Test that the audio file exists
    assert_path_exists pkgshare/"zelda-secret.mp3"

    # Test that the installer script is executable
    assert_predicate bin/"zelda-login-install", :executable?

    # Test that we can run the installer with --version
    assert_match version.to_s, shell_output("#{bin}/zelda-login-install --version")
  end
end
