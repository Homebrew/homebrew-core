class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.2.0.tar.gz"
  sha256 "f1951282118b6edc56a005c4b930c0393b6d97c3fc13a565a9d5ef174e2360bf"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "420213adbcf95b0d337acf1501e6f89293010d0b79a90dcc3e8d45740a2042f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c8857515f7f8192cdd84a55407ef8b4ce825640509b5cfa642a8bf5ce69241f"
    sha256 cellar: :any_skip_relocation, catalina:      "6b84a5d32b68ca4c1f2a57153b3ab395fee39c1172011c771f5f8bea3cce1293"
    sha256 cellar: :any_skip_relocation, mojave:        "504e11dec505ed4abc3eaf6d10cb6adad8bc9374aa726497b307e22c4cfe6463"
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
