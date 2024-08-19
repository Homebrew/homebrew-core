class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "3d0137ac50c6e6a9ca2865b00e41957ca8e9725bab490f372176ae35be8e9f5b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddbbd345684c620f23a0b82cd4bf6b5b65a092d37df737566e679386b0c3f686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f1009ed637fe5f209c1c108f4b1f9aef6b20d2d19821dcdbfbf81301961b632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "232d07a4ca837a634e450476e18593c89e2465e7aea56a36c8aa47c57f8f7bb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ac74c76de23dd0a3abf3bccf852d8b9a3720a7d9275546e848532f3483b551b"
    sha256 cellar: :any_skip_relocation, ventura:        "d2cdc15c9820b52fbc8c8ae2af9268f6ebca34a7a2d0aa6abf73ac7604427620"
    sha256 cellar: :any_skip_relocation, monterey:       "08394e91c4f00c9fda5ce37c2d6a9718d116632828f8afe8c7c30b8a4525777e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8071389dedb0aa4d307ca52dd7b69168133769f549a9dee435682502f9cf7a5f"
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
