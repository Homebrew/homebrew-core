class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "985010623436bb3b6e6828f9ef2b005cdb962fb6f32db4a29fd91e3cf3143a07"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a583eaac0abe5b051b88007433f8a0b4a7ffd5e757db6ff2cefa6974d62b699b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6c53369ef112ca9bd66ef0a04e7ec9896a7077218b273287a76ade3cf07572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a65c8c071206d0528894f788ed2fa529de51a2c9bafe631db98377d21330d785"
    sha256 cellar: :any_skip_relocation, sonoma:        "657c49dcd16188f25c41ff49b3d5f9b90f9db64abd1b9f1a9d6b99484ae20164"
    sha256 cellar: :any_skip_relocation, ventura:       "1091fdbc8b75b742d6b3864dafa95324bcc8346b61247e31366999122d1824d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0e56ba0bbfaa53f36daf68b12a8b1191c94841c168376ff394e9e5b928d5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e4fd7d41c1aeaee8293f4a6d506ddd33f1f2b38f1ebba5e3a93ba4ef6d565b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
