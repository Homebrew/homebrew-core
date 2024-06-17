class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://github.com/uutils/diffutils"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "3b1f37626558c15a37111846ce9de6cb88fb2e3290d7068a151cec1d9d7075c3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8062f9026d66055de0f4aacbcac36f84cfbe0b523cb8ca309b8cc6e27497fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b70e7b18650c5e9ccb053bd2e52c96e71ec467688d152e40e1d5b1e1786d595"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a427db6666e2be294ef8af4e5cba551bb2275330ba224b2da03cf11dda8ab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "90dc7729e9c5cfe313ba69216203446aeb387a33cb2c284dd0e13aef2ac45d38"
    sha256 cellar: :any_skip_relocation, ventura:        "b99d54a706967a2296c313036f61e4fa405811e6278158b546e18e22eb0381cf"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf8ecf9db10f49e10d416ea796675cc9eb2e772f7a317b71b18ece2cc2e75d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404f0392d776ea3b29cb6464d120c0c6804a0bce26c2fbe8d6b7e7ff7b817d45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}"
    end
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"udiffutils", "a", "b"
  end
end
