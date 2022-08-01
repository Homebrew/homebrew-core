class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.8.1.tar.gz"
  sha256 "85ae6a9ca5c81f9b30cfbf56130dddad9b57e2fc895a0eccf27a88dd619ae905"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b069e536fcee018c4d029722b7e9ea84eecbfc3d0ee5351ded6e1b7359b9d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4861dc9d2f9ac0a5e0c4ca2835c87cc6d883826e06bd894f11b22e4f6b50a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3afb916ab06bca97a138fdf4f1572f5be45a55e97ef7c9db44a80492f2b30bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "8240deaa1d54bed67575da03051af4341f7c83e459db26e328b4fa055e7d44c4"
    sha256 cellar: :any_skip_relocation, catalina:       "9770b06eb3700104842d198bc429c79fc3404c6192be8ade88d19c70679e0dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4e5eb86414d44254a152db6b2fdaefeabe420a216485314684a445caecb6bd"
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
