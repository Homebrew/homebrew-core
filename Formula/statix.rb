class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.0.tar.gz"
  sha256 "c5eb2ad2d060b197f6c9df08b79836026a761120d664e81b11e09faac82189ba"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "351f0b09937f9d162339269a70df4ee02311d73b697d0998bead9d64d9b49198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dfb8088d1ffa4851a80bccba5a4641491f75e9f7b2c49e750247e7ec9a42b91"
    sha256 cellar: :any_skip_relocation, monterey:       "aae2aff294a787f8ca547069d46fb6e3a794c87ba86cf822a6beddbc57fc3e1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "27cbc972b6e6c864efe020cd63822b26862a9d35ce7f741c9434048b01111728"
    sha256 cellar: :any_skip_relocation, catalina:       "0f31560156981216966406205fe8f6d26718c9c850b470cd4c0aabedc00b835a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f897038048b5d14b22d3d983b555bc2b8a656983e5327a09e09bb09f2c33fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~EOS
      github:nerdypepper/statix
    EOS
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix")

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
