class ZshYarnAutocompletions < Formula
  desc "Zsh plugin for yarn autocompletions"
  homepage "https://github.com/g-plane/zsh-yarn-autocompletions/"
  url "https://github.com/g-plane/zsh-yarn-autocompletions/releases/download/v1.0.0-0/yarn-autocompletions_v1.0.0-0_macos.tar.gz"
  sha256 "7bfc7526e0567387dade1e0716ac9ca0dd14c199946d2e31c43743087a737a31"

  bottle :unneeded

  depends_on "zsh" => :recommended

  def install
    zsh_completion.install "yarn-autocompletions"
    zsh_completion.install "yarn-autocompletions.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:
        source /usr/local/share/zsh/site-functions/yarn-autocompletions.plugin.zsh

      Don't forget to remove that line if you uninstall it.
    EOS
  end

  test do
    assert_match /vue/, shell_output("yarn-autocompletions add")
  end
end
