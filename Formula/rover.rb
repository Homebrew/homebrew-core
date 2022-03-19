class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.8.tar.gz"
  sha256 "e95c5f6f01efe4381334cbd2637bf9f8c849855b0705a87cf4d5c5103bc4ecdb"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301927260be3f62e97543a20494f2b2c9dbd600806ba5fc5e0b8929b29ad78cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6908740e8b77eb540549bad67494a4138da5620c9f2cfd0f6a01a88536bb13f0"
    sha256 cellar: :any_skip_relocation, monterey:       "5cd0455ebf21f1dfc51dadd9f136d0855ef9dbe88b3c01bb5443f4d30b7e3130"
    sha256 cellar: :any_skip_relocation, big_sur:        "b622853c27b15d509fd924825eab7d2a62c7b0eebe03f90821c95c66c42579de"
    sha256 cellar: :any_skip_relocation, catalina:       "e4b27ab77b089f555617e0cb26a9013a4be0e70f44ae12878ce508af6a0320d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11bc79786da2ab8b392f63b07011eec8a2a6e7802634d437de9cc84a2522ce33"
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
