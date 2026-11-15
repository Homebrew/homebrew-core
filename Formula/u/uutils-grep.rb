class UutilsGrep < Formula
  desc "Cross-platform Rust rewrite of GNU grep"
  homepage "https://uutils.org/grep/"
  url "https://github.com/uutils/grep/archive/refs/tags/0.2.0.tar.gz"
  sha256 "aabb48c5f14aa46befa4b0b2848889d3ca2ff819d5855acfab590f7f47d223b9"
  license "MIT"
  head "https://github.com/uutils/grep.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "984801484e5d2a0f49f770ef2e9102d6abd760a58be266fba5ba388c4eb83227"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b768cb03db8c9e3decfa900cd1daf4428809d0386eafcf8f6dd16f66d901797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "802f217809f43e0b9a796955d91dbd2fe01a4a125ea4448daef0f13587560c1a"
    sha256 cellar: :any,                 arm64_linux:       "cd22a674cf11a2fffdc22e6743518c4ebdea8aa4bd4a7d4c3ba36f960a9c157c"
    sha256 cellar: :any,                 x86_64_linux:      "37ca6377df555841573f8f3de61ba901c772f1e94e058764e779766810c91995"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    uubin = libexec/"uubin"

    system "cargo", "install", *std_cargo_args

    mkdir_p uubin
    bin.children.each do |cmd|
      cmd_name = cmd.basename
      uucmd_name = "uu-#{cmd_name}"
      mv cmd, bin/uucmd_name
      uubin.install_symlink bin/uucmd_name => cmd_name
    end
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    [bin/"uu-grep", libexec/"uubin/grep"].each do |cmd|
      assert_match "should be matched", shell_output("#{cmd} -P match #{text_file}")
    end
  end
end
