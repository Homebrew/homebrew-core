class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.5.1.tar.gz"
  sha256 "5382cbafbfae451a12dc43c0d6ddc529199e5bea9272e2a4fad13ed44c388c44"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40d0a13e5c630bcfb7341acbaa9e3c6a8308290b59ba3cf59b151a2ae09d93e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85e9084fe52f5ab66c5cca89ed67503640af512a32dc555410c3abb55b9a6502"
    sha256 cellar: :any_skip_relocation, monterey:       "be7986d50c73cbfe8c8b7ecfe4f869fed1f0f93a39bd6db4ce090b6b70f8d6df"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a77c1045731270a4f6093b332ae99eea08b1abc09c4beaa783b930133133c08"
    sha256 cellar: :any_skip_relocation, catalina:       "fcf4538e5d77791ba91ae1b8dacfbac60e8bc34bd99bf650e84666ac730313cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ca74cebd01b5f56d2e7f8ecc09740b02bce13e2d370184e263d344916e8210"
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
