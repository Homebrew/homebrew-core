class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.2.tar.gz"
  sha256 "972a5e2f41def98e5fdcee5020aae46daffade0cd4e2eb49b33def15f1675166"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13c34dd86245ebb4d52b768ea91c016c9d3aa59ab70509ade4c90f7628953ff7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac015e600432d969183c2ca7f9722bfc80c91c5d3c0665ea87d3036a7c086c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "553c56bd201ba1e0c7864bbd940974db77240ab443bfaa9505a499228a1f95a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a267e6097d9a431fe67e3f96154e282c0d7e288374d6f0d60f78ffdb65d41b92"
    sha256 cellar: :any_skip_relocation, catalina:       "3bbeaf2cb0a3abc0059123cd7e1e08876a431c4f551815c170acd40f848d9e7b"
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
