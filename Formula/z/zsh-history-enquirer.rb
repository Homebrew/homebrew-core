class ZshHistoryEnquirer < Formula
  desc "Zsh plugin that enhances history search interaction"
  homepage "https://zsh-history-enquirer.zthxxx.me"
  url "https://registry.npmjs.org/zsh-history-enquirer/-/zsh-history-enquirer-1.3.2.tgz"
  sha256 "eb5fc111b9122974e086f625ba6b46accb8e06ee7cad9519b0f2daec098f7ff1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60dedf5a5d359d96f5bdb7ce3bfbf3e87c145b95082781a364e39437b17fea86"
  end

  depends_on "node"

  uses_from_macos "zsh"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    zsh_function.install "zsh-history-enquirer.plugin.zsh" => "history_enquire"
  end

  def caveats
    <<~EOS
      To activate zsh-history-enquirer, add the following to your .zshrc:
        autoload -U history_enquire
        history_enquire
    EOS
  end

  test do
    zsh_command = "autoload -U history_enquire; where history_enquire"
    assert_match "history_enquire", shell_output("zsh -ic '#{zsh_command}'")
  end
end
