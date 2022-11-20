class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0ea77daf31b9740cfecb06a9dbd06fcd50bc0ba55592a12b9f9b74f3302f5c41"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d18d9857bca2588f382d1bca504abf1f6df144947036c0348e363dc22e2fdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca045c4e12d1d6755a9da9eddf1bd13dde2b0d73ad1e65da54d371669088a6de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7481db500d7ba0560895918bde9e9e0528a8c5b94f8840d0147c782529c3d49a"
    sha256 cellar: :any_skip_relocation, ventura:        "c40f19a23c50f9a71af077d37fd11519090bd4d71fb3d393d63e1aabdb86a176"
    sha256 cellar: :any_skip_relocation, monterey:       "cde20a32a79062807f5c0af35665c19a94a1581620962ebd39f0013ee419b317"
    sha256 cellar: :any_skip_relocation, big_sur:        "b329e0a3499b2ea64883fcbbd841647dae919bd07a8d540e93bc7fb014665338"
    sha256 cellar: :any_skip_relocation, catalina:       "20e961b0544246034d484f1b81ebe5058a3b915afa489a8b7c897c49b038952d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b3394d4fdfe9fe4620892049fe5d27736696416a8ef7c43b007cf418e223ee1"
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
