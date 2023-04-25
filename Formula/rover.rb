class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "fc03e558708336b82ba8f0ea03fdcc35e7c611f34b3c0946e4ff5377c18b2f87"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b81404144f811946318aedaabd2d5edd2cd9a55daebd32516df290c3429b346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e43cf3620f118d2451d0497a95826c6cf56a6474e3986b3405368f2b871d2d99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf586ec4b7626a4dbecdc1d4d984e519e51d7df33054fb01c54543039e2f2ab5"
    sha256 cellar: :any_skip_relocation, ventura:        "501e46d4a0acef4d5f7c46b5a6c5b45a32d463ab81c9fe30a76cececbab1d45c"
    sha256 cellar: :any_skip_relocation, monterey:       "910aaebfc76219232b7742d5e0cc4903c033fe682dd7129aabd67f6deae436bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8177690835c28eb9fcca939fd04b33bac07d4391b9eabf1d5862bd6ee7211abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d148347e8b0be29691021222d426f0c8b787b732ae7129abb7ba8f7cfdeeb52e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
