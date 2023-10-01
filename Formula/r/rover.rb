class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "0b0f45d4cf826ead9d7913bfcaa263033a281ff1ea8f4cfbee73553612babff2"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c259241719b24f8237b9767ad775c05e0ae290a34f79ded40b836c486f9797c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad839ddb386d793f309e4fac4a798be661431ea11569f0122cedc9c4ab98c88a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb63c547ce83fffef78b6e410d054381924e3614eb474ef67b3675bda6025d5"
    sha256 cellar: :any_skip_relocation, ventura:        "8b5bd5d1bf89bd6500c69e8c46cb4c349547d8e799c72ac4445fa2b71d70312b"
    sha256 cellar: :any_skip_relocation, monterey:       "85b35b442440003502966c90b9f4fd32266d3b489013defbbc7529f9f9dc72e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "784fc318b57ef87d7cc6b73edb10417cf33f1c107e6d309a4e52e2d05f29af8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e135d5318ecd4c57202f5262275a2ad0ee3ac3c34f2e3c5f255af68170a0e01f"
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
