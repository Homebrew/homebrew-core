class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.8.tar.gz"
  sha256 "e95c5f6f01efe4381334cbd2637bf9f8c849855b0705a87cf4d5c5103bc4ecdb"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcb7edadbac703185c7950060cb224c5e7a86070fc6997e83aace0806a0c40a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b61181d985c3280a1cfb4c2455c69379fc7d9c0cdb4f2ab13fc4223dc0ef1c66"
    sha256 cellar: :any_skip_relocation, monterey:       "6fe44d591a9d231c1ba85320a0f5b5b3e8f2b004e7d7ce34b4f571574ace24e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbc7c58a83a3debbce8bc09bc6413afe69557c78be44992f757468922488921d"
    sha256 cellar: :any_skip_relocation, catalina:       "97cd0ce38a498f9d9e84b863c6aa29a49f10ecc6bd95a8e1275bc373f12a5353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b224c1d9abb7136f47a34e41a7e98f2efac44c6b82cd2fc1bc590cbcaf0e9210"
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
