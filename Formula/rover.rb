class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "335c848c1b6df2bdb08923ff2282f267ba355bff71b15762af5bc76ec439a506"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf4f0ffd624975b1c6cd6d1fa222ad6c90b084fba97198216f4710e43a94f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "704def7e605d60b05a5d295bf647c85368ba43a024de6e64a69422f46316b828"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d2ccfe69fdc366a89b196879f462c19e84ba692bef6c6405fa14483044578e"
    sha256 cellar: :any_skip_relocation, ventura:        "a144ab3027e575ab76447929f747e1d147ff7b8ea8170b453b2a3db81d4320c7"
    sha256 cellar: :any_skip_relocation, monterey:       "304aac1c12198314b673a3c6c431b6ab38c9fdc011fed2c6372fe5aa9620172a"
    sha256 cellar: :any_skip_relocation, big_sur:        "68152cf8c5f8be70cf2dc86311124d34d1cf76e1bb3eab4563d7c244662d6e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f84a32178c337f85c5b90ee36f945feb2f9a4a55699b21e00c91fa0d997f684"
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
