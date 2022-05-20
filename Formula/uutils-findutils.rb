class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0ea77daf31b9740cfecb06a9dbd06fcd50bc0ba55592a12b9f9b74f3302f5c41"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b9afb8c023172346ae4c0fcaf09a5b3ae1902947e63eb7966cc74eaa5497727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d66b8426c09906c18d3ce3b82d082caef83d5cf701a3858fe49fb8d02a9bd81"
    sha256 cellar: :any_skip_relocation, monterey:       "9a75049acd7a12e7db1bbb38a97b7b66e1425332f00258347b3821e7a435e6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe2889981a6503b67a0c55ef7d8cb2dd8e078480f298ad577e86791b74e7f3e4"
    sha256 cellar: :any_skip_relocation, catalina:       "e486fbe2380550b180a10bd9bff432fead265be2430889c14d8c885988f447f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3595b1ba387b3d1c2139edb0ca4612cf393929b4c59a798712e69affeb331a7a"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.linux?
    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}" unless unwanted_bin_link? cmd
    end
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/ufind .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")
  end
end
