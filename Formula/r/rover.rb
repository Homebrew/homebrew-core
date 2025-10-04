class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "b176e9d137dec3a80495efecf3c1227bc38ce1c44f7a018748858f491bb4a010"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26582b2959e3d939ba2d0e18ec07c7e2e0f6fa34d78c862e9586c549933713e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890bb39f17f71dfab2f4034584734cd691fdac644c271bc41e3c38f2a0576d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c640298c5372e67ea1e135a25887d2344ecda6dd9fc9d41c0eb5755d1ef3182"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9cb87cc4876d886638e0d30466d5024918b73e4b85583441c8016bcc8d723a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "173b8c9f0e7d2122f78136a5cf118a3bf782211f09dd021637eb7ebf369bcc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9126b2ee4ec3d7a3b86845714165e553c20c94950403b22ae6b97cbb8a6e25"
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
