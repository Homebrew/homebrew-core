class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.4.tar.gz"
  sha256 "a1efab4ddccd7577d8ebb37b94ceef0e820d08a90a951271fce9a9c1941f6a75"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e079d33df969a538cc92d271fc5fecd367091b098de5541155ece4889e61f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6bde4e17d610d1f5deddef4e6e1ce668add920bbfa68e3eff5973e02f627ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c7c21a3f91692e31974bc566a8322e5f26bcda8e2091283567f3496f561d24"
    sha256 cellar: :any_skip_relocation, ventura:        "a133585e506efbbc1e234b919a9c14b1f36b6711d884ca8c5641134b2f30ff77"
    sha256 cellar: :any_skip_relocation, monterey:       "edee437b5f8edeaad8a2f19d805a90a77d14f0742cf8a5c70ac481ec824aeaa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f1aca5bd8e3b418829a50a7f034567c8284704b874640f2ab121c3491440b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3667a91430a51c6b091ef5bb295082c43afa3dcba126d69a6d1af8a3ea6b5015"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
