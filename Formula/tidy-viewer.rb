class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.6.tar.gz"
  sha256 "e9a2fc904f2e115c715df80421c39e0f226b6750a56db96d994acfe9336ec219"
  license "Unlicense"

  livecheck do
    url "https://github.com/alexhallam/tv/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)(?:[._-]release)?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53853cd1533e4fac8e60888f9af81b3cf6ecf30ab9f3a05499e4043845180d37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557eab650f2badd470f82f807022a9d0a9b310f87744c122ea5f40dbcdadbc8e"
    sha256 cellar: :any_skip_relocation, monterey:       "5506df402aab6fb6ebea15dfc3c3dddd6352cf03234e4c9848056143b7b9150e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcfe3cd819e556c49a4c6aa0d44f14d46944a025653e93cf0da026932a0afaf3"
    sha256 cellar: :any_skip_relocation, catalina:       "0071398a81e37d8ce0598907b35fbdb6ee8dda1af963320fe633c6f47dd3a801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a379a4e3ede49e8692d386a9a13a9419b3f5eb719d4ba45b4ad66277456771b"
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
