class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "8f7448d44889ed6b3deee0ec17390c5b0e2afd3c34f9d469d03a80e24e3cea3a"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af606500a6f85b9735049a9de2aec6c81f289a6692eca42a54e9672f68a7b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc43f8bb756e358ca2b12a5461a9caa99075eceadbe206458489a37836422a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f727c95786c0be4659dd7b9b5cb14754187509aa3edb9d210b65119674b0e8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "1a1a86302d2c9ae706cbfff5202fdb56340966259b54e9c13b21afbf1c826690"
    sha256 cellar: :any_skip_relocation, monterey:       "ce69d863697ceb701d54a1f79cf174ee5c8536ef55f11cf99982a5c14400a41d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc1ccf122f5da13faabcb4608a3e30a021de638b2227992a071a2ed6a503fed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4c9efbd0c4c327c45c3b21cbf8c46bac96f0cde67a053f022b8e19237e8744"
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
