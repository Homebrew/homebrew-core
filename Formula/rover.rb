class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f2cbfbc80360903d734ee9f8e513465ee91d08cb4671924521978bd20138e10c"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cf6c6a10cb123f55bfe9c3640adbc41b14bd34022bd38b58955f5e578bcb5c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d1da494eb928dd3ea340db96719998e65c601df9fda9123613c19b367a13b79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b23f8f7dddc50f201afc7450c74b9e060c3be05ec622c6da994ddd85d6a1e18"
    sha256 cellar: :any_skip_relocation, ventura:        "2e077de207deb33c1f19a3ea267fc7ff8f5a44c473b3a250ed606ca1e44fa1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e30d4acc1d211c92cb2d472d3107a1a90d1652056d3854f6e41b943eddf296e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b8639eb131b25b15f0daa990c80937cfbd214ece641244870337d4dfbe3c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4915ebc09a8a365238b1329362bbccbd9a4111e95350202a1fba0569bf94046a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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
