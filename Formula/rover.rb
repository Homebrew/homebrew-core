class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "fa0efe7e0174031a0baa6bf4362d884b9cb78d3f955df541739fee51380a7a53"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f67ff65fcd155f5351f9922785a2269eaa46ef7cc060d9baaaa35bd1a48f79c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1089be020d093d45da55b1476634c3d320095e29e9b4d6f69dbb300b4bb51ed6"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb07038a74f01cd7fd17f138f862aee6dac71a1da96d524a27b05981bbf5274"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed455435ea9496dc734e75326b4d3e68a94a734db9f1fa26441d635aecb8593d"
    sha256 cellar: :any_skip_relocation, catalina:       "8412192fffa05052b12987d6834b12bb6ee3bdafcbae0f3c65bc594d9c7ba24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79e0de058c6912c7228135ac8dd55f9527e0ffd99360ba086f0667545ea5258"
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
