class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/releases/download/v1.17.0/zimfw.zsh.gz"
  sha256 "31fa45e3f2d486d2f51de190b32280c0b4adad0b26673b8aac63ddf371eefd78"
  license "MIT"

  uses_from_macos "zsh" => :test

  resource "zimrc" do
    url "https://raw.githubusercontent.com/zimfw/install/f56ab9c93c8ebc906901001b4a672edc3cb643b2/src/templates/zimrc"
    sha256 "3ab3f9563828a5f26ef012b480ff0ba84b7244aa81551c178388890e294ba6ca"
  end

  def install
    share.install "zimfw.zsh"
    resource("zimrc").stage do
      (share/"examples").install "zimrc"
    end
  end

  def caveats
    <<~EOS
      Get started with a sample configuration file:

        cp -n #{opt_share}/examples/zimrc ${ZDOTDIR:-${HOME}}/.zimrc

      Add the following to your .zshrc:

        ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
        # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
        if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
          source #{opt_share}/zimfw.zsh init -q
        fi
        # Initialize modules.
        source ${ZIM_HOME}/init.zsh
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'source #{share}/zimfw.zsh version'")
  end
end
