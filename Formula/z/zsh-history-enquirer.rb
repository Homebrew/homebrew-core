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

  deny_network_access!

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
    (testpath/".zsh_history").write <<~EOS
      echo homebrew
      ls -la
      git status
    EOS
    ENV["HISTFILE"] = testpath/".zsh_history"
    output_log = testpath/"output.log"

    require "pty"
    require "expect"
    require "io/console"

    PTY.spawn(bin/"zsh-history-enquirer", "brew", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [24, 80]
      # first `node` launch on CI macOS VMs can take over 20s
      refute_nil r.expect(/\e\[6n/, 60), "expected cursor position query"
      w.write "\e[1;1R"
      refute_nil r.expect("echo homebrew", 10), "expected the filtered history"
      w.write "\r"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.kill "KILL", pid
      Process.wait pid
    end
    assert_equal "echo homebrew\n", output_log.read
  end
end
