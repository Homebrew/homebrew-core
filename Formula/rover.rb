class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.1.9.tar.gz"
  sha256 "4a2ea6d666efb1de9e9ca8bd35a05c2d175b814e6c24caf7c58bcec9b8044001"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "06f63bd453bc1bafc5fa22a58f4d9c07b74d6c7785447a6e75d42de5c15dd5a1"
    sha256 cellar: :any, big_sur:       "8dd523743630c974ccf91a0860eff4fe63f348dc593003ec54d9661c6397ad36"
    sha256 cellar: :any, catalina:      "0e2dd6cb5dbde1dc67181f98a7d81c86fa834172e526ae2118948edf3d31a7a8"
    sha256 cellar: :any, mojave:        "cdecbbd512e03001025e67cbfb8d999e63c34962bc98ff04d57a83691caab1d5"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
