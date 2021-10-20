class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.3.0.tar.gz"
  sha256 "1ba8ef546cfef89517a8ee9932aae683cab523d212ea8d3d4fe1359a15aa3be6"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3c28dee340c5d18824ef959d7145f98a966c2f8cd146492da690c013aad99b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b640a85eb294dde65314c326d5e9aab16c9fe3c6bb3c4da58789c05d3a5e4b65"
    sha256 cellar: :any_skip_relocation, catalina:      "4586e7cdb5be12987b12e0219b437c5739ef539c551715b223ad4fe0f3a9e498"
    sha256 cellar: :any_skip_relocation, mojave:        "36ce99d78667ec47385cbc36fece4b144aa7fccd29f85aae49ad59b30f33a3d8"
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
