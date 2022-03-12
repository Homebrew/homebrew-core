class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.5.tar.gz"
  sha256 "7c9c0b82757d03bf666ec3b80fcbc9a6e9bb51d27da0b0764bd4c262fd619a42"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee45c85a66e9149b8fb8e8009c28bf6c1d3f494d7efb93df8f33e7eb5978f35d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8139acc8604294f55fc4c6d7cfbb08e9884b9fc907ed28766538102322d1aaa8"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0fc2d423300daa836c856bd906260eb1bf888c6a34a4831ac36fad4eb2d92f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e819aed1a233dce6c897c58131e36bdb390ad6c08a19878ac1e15ed2a2d9980b"
    sha256 cellar: :any_skip_relocation, catalina:       "87e30f6b49ff0dd394e7cea7e04c005f3657b767db12c8dd605f37a3e685a714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f24dc0e6248c645e8ca9fd71d47b707e8b51b185248d7518d6e55fb7a56a18"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

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
