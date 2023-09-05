class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.6.tar.gz"
  sha256 "ed4e05c96541372d917691797674bacc1759d6a1c2d621fef5db650dfa34aea7"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "127c64e525f291f13a753e93484cc6261f5cf08fe8e631aaaf9bbd0c07dd80d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a341c31ecd2a97b20d383a6a06761ee8902977d660da697cdfbf16d18587fcc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "027921b88c04e2246da514fe0393e84bb82f0c077fcb3116a0f2ee58e169a969"
    sha256 cellar: :any_skip_relocation, ventura:        "371ca555c23fcf6e2851cd3a3fba46dab6dac0be4cc7d228a13d2f705fbfa0cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c9bec9a03e1fdd1d7b2806cd8d84db05950a22aec908cfab67314430134925dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a677e57aba3eae126b72090291c2e4ee96a6b3cb8403ed66b04eadf6b3a7cac"
    sha256 cellar: :any_skip_relocation, catalina:       "f92e2af8ddd288908aaaebb1016fa5156132d0c3c6c20b8e432c1302fde03e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa6f1785699aaaa668f5c389ac5866f717c6a3ab0f2d40961259dc6eda92790"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~EOS
      github:nerdypepper/statix
    EOS
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix", 1)

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
