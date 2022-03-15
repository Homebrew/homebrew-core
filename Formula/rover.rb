class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.6.tar.gz"
  sha256 "9713ea4589f6ea00d6d2f3f9fd56ef8d4a15c39d179dd35965d4c5147e2e95f9"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "648a4fa8414956578ae05f1c28e52b7d9a8f1409fade31943c682b2d30fdb8b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28881b4046f8076c02bbfb9a25caa77599d37eb4945fb8c93a8e94ccfdc54861"
    sha256 cellar: :any_skip_relocation, monterey:       "3f60aff44642c1b710c29e9ee843d81d6a7663c2eb3ec3622d8bc30003bad46a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8efed2ad0ef8a638f49235bc02131690bb2967bb56dd28b56bf139fe4fb40389"
    sha256 cellar: :any_skip_relocation, catalina:       "ad9cf46dc67b70b71449adcd2ff2b407e84bad8d629e44e27359550d74080b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27ecb89572553012e7a6cdf63476d16ea8e254606cedee4a018c5cb6db8ded3"
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
