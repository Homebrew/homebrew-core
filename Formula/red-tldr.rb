class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.2.tar.gz"
  sha256 "94cc5f195fac8617873f30616d65eba4b44b2ce4c58d7b6a5f8e2bbceef569f4"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac41d14d086161d978917fbff76d3395b880a3893a9f4796739d17c410c9faa5"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a939af88b73b710341f01874d2fae08b4cce52264cac7622dc92d8716081af7"
    sha256 cellar: :any_skip_relocation, catalina:      "e167991c8c9d3c9672ed5b0d2d7ecc5bc89f2a27721868b22a2bfa2c6cb26917"
    sha256 cellar: :any_skip_relocation, mojave:        "0bd47cfa0c3c06d0d5e1790284aa0c2357af8ec1afee06bf9c8cc4c129a0287b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eef7a08fc5ac0e0158a17e6926b223c4b72f1e1b786ed55f1660edaf24e34b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
