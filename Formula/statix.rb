class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.5.tar.gz"
  sha256 "d21dae937808133545bb74009e9cec5ffc3623b66638e427ffcd195e40c7c2c4"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616733e57459b6073fcfd34c07069a6c5bca498090970b33ce1d10cfc645a64e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc0f806c24839e45ae9eef2303732c9f5dc4e580474e9488ba79c2c702efd5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "fec35b517402a4c157eb298603230e9b361ee5a9522142e3bd74404121d71a3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "92dab4d428b0286a54a7022ec1aa5fec98225dc2843da193b26028854e860a79"
    sha256 cellar: :any_skip_relocation, catalina:       "4ea97d3a7ed8a69fdd045d6318ce77a44ce3fbe9a0201065d6a57cb8e6feb06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e767f6a96725ac3a1cd42190927d4b856e2e4ee29e35dbe7d2f871a81482e6e"
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
