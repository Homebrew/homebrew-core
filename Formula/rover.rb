class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.2.0.tar.gz"
  sha256 "f1951282118b6edc56a005c4b930c0393b6d97c3fc13a565a9d5ef174e2360bf"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "883e4c458c5c797506ecb63736a771563a41563893a914d3f3e057e0d3ddd32d"
    sha256 cellar: :any, big_sur:       "322aaa349d24157af30498a398bab956bbd1e26bb8df5195b14ee80456813d2a"
    sha256 cellar: :any, catalina:      "a82c3830a51192762bf7517c6c5d86ef6ab5313b7c5538e4305160c78574697a"
    sha256 cellar: :any, mojave:        "135db358e9253361c63458877e05738eb1883d8296dd010ec43fdc2263a5ac93"
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
