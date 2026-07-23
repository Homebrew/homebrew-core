class TmuxFingers < Formula
  desc "Copy pasting in terminal with vimium/vimperator like hints"
  homepage "https://github.com/Morantron/tmux-fingers"
  url "https://github.com/Morantron/tmux-fingers/archive/refs/tags/2.7.1.tar.gz"
  sha256 "5e62f8550787842fc712203df31f7eaa723f7023ab19bc97d28b3b85e2d7c420"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d2e30632b6a39accee83f12addaae4c40970084b5cd3155a3789152762e4a0f"
    sha256 cellar: :any, arm64_sequoia: "bd8a0bb8472953e836581a9199d52cb37df881997d2499f0ca4873f8481e3342"
    sha256 cellar: :any, arm64_sonoma:  "5c6a364d0d1e6e9dd9d4f604e9d9176e8ae8f397a26368c5af5bac6a33408535"
    sha256 cellar: :any, sonoma:        "ecc99a0aa7b7bbc96cca470b52085b6547b825b6f7a2ef2bcfca8cb6826f083e"
    sha256 cellar: :any, arm64_linux:   "af704b9aee86835ba1aaeb0ed82d8aa29f0e6471819fcbf57202188c4eecb520"
    sha256 cellar: :any, x86_64_linux:  "058d5f5ddd816d7a41f6074f51220ef51365aaf9c46bab3e712926970f94263f"
  end

  depends_on "crystal" => :build
  depends_on "bdw-gc"
  depends_on "pcre2"
  depends_on "tmux"

  def install
    system "shards", "build", "--release"
    bin.install "bin/tmux-fingers"
  end

  def caveats
    <<~EOS
      To initialize tmux-fingers add this to your tmux configuration file
      (~/.tmux.conf or $XDG_CONFIG_HOME/tmux/tmux.conf):
        run 'tmux-fingers load-config'
    EOS
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_STATE_HOME"] = testpath

    socket = testpath/"tmux.sock"
    system "tmux", "-f", File::NULL, "-S", socket, "new-session", "-d", "-s", "tmux-fingers-test"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tmux-fingers load-config"
    assert_equal (bin/"tmux-fingers").to_s, shell_output("tmux -S #{socket} show-option -gv @fingers-cli").chomp
    assert_match version.to_s, shell_output("#{bin}/tmux-fingers version")
  end
end
