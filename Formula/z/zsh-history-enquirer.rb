require "language/node"

class ZshHistoryEnquirer < Formula
  desc "Zsh plugin that enhances history search interaction"
  homepage "https://zsh-history-enquirer.zthxxx.me"
  url "https://registry.npmjs.org/zsh-history-enquirer/-/zsh-history-enquirer-1.3.0.tgz"
  sha256 "d2b673fdb0621bbbbae1529f42ff0c3184fa8e4f4befbc6bd9fa4b2d95ca4b5f"
  license "MIT"

  depends_on "node"

  uses_from_macos "expect" => :test
  uses_from_macos "zsh"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
    (testpath/".zshrc").write <<~EOS
      HISTFILE=#{testpath}/.zsh_history
      HISTSIZE=2000
      SAVEHIST=1000
      setopt INC_APPEND_HISTORY
    EOS
    (testpath/".zsh_history").write "echo one\necho two"
    (testpath/"command.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/zsh-history-enquirer
      expect "*echo one*"
      send -- "\r"
      expect eof
    EOS

    assert_match "two", shell_output("expect -f command.exp")
  end
end
