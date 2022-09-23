class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.9.0.tar.gz"
  sha256 "d296913937fe786bc9d5915ebd41adb993967836bed97bdc5fd0163dc4777213"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3938368b30cfb1c83f5266c6a6e3bb575781a993798b6888fdae5a098bbdc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2051e946ee485aa99d77550c511df3a8b646c3127b2dfa3abd17e782a7fc183d"
    sha256 cellar: :any_skip_relocation, monterey:       "b3859885a79c3910c567b0153677e00cc98995a88c9d471be0b924a069c9fa50"
    sha256 cellar: :any_skip_relocation, big_sur:        "28068b85e95a4bc52d94af7e0cc7a2e0fd0bd2be0f3e07105f275348c5588be2"
    sha256 cellar: :any_skip_relocation, catalina:       "6c0384463d041649308d458d559437355af3d90b88a9c7995f9e37b6e083fafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0acadd08a91eb8270e7612cf9445622671ad5c95f9fe041640b528cabd64cbc6"
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
