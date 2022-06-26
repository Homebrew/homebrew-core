class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.6.tar.gz"
  sha256 "ed4e05c96541372d917691797674bacc1759d6a1c2d621fef5db650dfa34aea7"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f2725bb833bbd7d01c0e6490704561de8b2f60ad6b7301e04df541876896611"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f959d28ba6724738ba67cb0e78a2192a1f74247748a8d1405032855f892e2746"
    sha256 cellar: :any_skip_relocation, monterey:       "0551ac6150f1cb190d00e0c4ba2177724165a544b44ac421746e576ec5028dd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "706de39d4b5ff85977656949900fe66cdee35fa0042abcca16b7324d12abf3d6"
    sha256 cellar: :any_skip_relocation, catalina:       "5a48aac0ccd1981df7a42ff682155457a54d419fb40b6cdb5f05557be1d75424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b27c405541460dcdaa4297e88e9fbf3c43581b3188a54b9e788d1350a406d93"
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
