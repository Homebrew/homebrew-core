class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.4.1.tar.gz"
  sha256 "6d6361a46e59c43b7bb2a5ba358868c6d11c060a316e6a9dade63ab5138bdda6"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86de65d5339c76c3780f5be28ad620588e23c76bd27a36833568492262c5954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eed0fd36598023b1dfaa39fd486304a57b7fedfa886d57babd8ab93c629a239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8cf9ceb3b93e17da5782b55e461bff061207e95f7878d4ed0a8aa4cfd4e3a48"
    sha256 cellar: :any_skip_relocation, ventura:        "3e1cc8d6abdc9c4fa35413b60259e95bd7acad5b89399288e9adbee84f93a4d9"
    sha256 cellar: :any_skip_relocation, monterey:       "d02af318757bdd30955a969130a676f7313bb1f68b84639f9e62cb20e84623e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd344393bf336bbd6b6c48d595570e2904a83d8ca9d1bee853be3d68f8340bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31432f27d81bb1ce83901e3ee13cfae2d02c8e25639d708756df19c114093f7d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "llvm@15" => :build
  end

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm@15"].opt_lib.to_s if OS.linux?
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
