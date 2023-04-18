class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.4.0.tar.gz"
  sha256 "080d01a7cd27f7afc342c3d6355ea1eb39ec2558c135744201f2064cffe4225d"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35bd72e9f6b8b093d202e93087952392888ee0deb214fb3baa128f5e144e4ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3929e14c3bc2f705b57b3d1b8373520d03fec4716a6f866bdb492aa92093ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64b653ea337a20d495af2d73c814580f62e36d37c2f254c97bb69d05f9498f73"
    sha256 cellar: :any_skip_relocation, ventura:        "6bc17ee18be1de4f46fadc17a35b2bf75df068a03b7b7ab3cf719bcfdaf4be3a"
    sha256 cellar: :any_skip_relocation, monterey:       "c911271402ebc0148bac30e332325e1d3a50379fc5afee3364262a3aff275c99"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a0cc1f20bfc100ad910a3eb5a7470bae90ede38d6ee1222e2622341df9166fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a093eeb22012bc45e4dda4d04bed07c559f4cdb60bad70502f65e9ac65d32090"
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
