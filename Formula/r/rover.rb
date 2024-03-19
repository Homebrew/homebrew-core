class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "660e770be20475e7cd1f49e8a43f6fc298a49e6327118380038415ddb18068bf"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af637c86620c0232912d4d6d1ef1b25f0e71f3ff956a2777fb1d4ed696394fac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4b526b6c06caebe5242aff5ef43ccc23b407caad9f3cbe5929cbf1f277cfd43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b18a4fcbf280f033c9ac65e1364946aa1d3e97ee114a7f9ff2527010e721e06c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b86c02848bf850b53b5c3c7c47f1977ff807aff3ff5b54890aa13c18d27030f"
    sha256 cellar: :any_skip_relocation, ventura:        "4d96d56c804bf7a50f53d9093c78e41b5fea4a6090df2ae5275b63b5006f8866"
    sha256 cellar: :any_skip_relocation, monterey:       "35a1db1b6b36abe83eef8f2882342ed9383234c5bc08045e0a6f0d380394ee00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff78234c74c8f8c577a09d3e763c1053a4d61e2b6132843f51b391c1b34ff87b"
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
