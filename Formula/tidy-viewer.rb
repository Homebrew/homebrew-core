class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.30.tar.gz"
  sha256 "52beddc07283396c7fd30097dc2ea37b9f1872eee7f2d83546dc93dfe644747e"
  license "Unlicense"

  livecheck do
    url "https://github.com/alexhallam/tv/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)(?:[._-]release)?["' >]}i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429da929eba086c22f3708e91b00e10825022f10e996d2553f13f475ea47edf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2490d337a310788ad1e95332dd7cc4f3badc9fd40d26084e58f6abfd0672fe2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "388a85cce1b3c584d129dae97ef8abf64d971545d71fdc891dc6dad3bcf73f22"
    sha256 cellar: :any_skip_relocation, ventura:        "1b68d696ead31a0553b49cb923ef8d1c19a80cf420d26a15677f2351fd897857"
    sha256 cellar: :any_skip_relocation, monterey:       "0013516e566f4828c75273d3661fd8b1e73b4067888b9c4678189bf4321662a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "114e75cc03febfb53edfe1d74e635f3d888f48dd3941527cb91f6ff275faf107"
    sha256 cellar: :any_skip_relocation, catalina:       "4f98a41949a4c78d3390491174fdfb3b31b23e436760bbba35a78030437cafe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5afd1a8b09449b7eea4602e2a0850cead81ffcb341253f9a16f0a209c6d5b5d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
