class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.14.0.tar.gz"
  sha256 "c61f611660306f5870dbbd037b55f8ff77db0cda03bbfa98cbc0032a31e6fa4d"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe6c262fc224a5ae6c68fd5908789ae8703156fe78f86c33a0a256855395a91f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c59eeb2d8a1826f051797c9c2a38df6e1b56f949a89ed94cdd63e7f08cc597c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9e75c0f168acbb5a9cabae59f029a62700ec5cef1a317da70a28cf75b1acc04"
    sha256 cellar: :any_skip_relocation, ventura:        "14c9a9e188fc706940673fb9a6bb51d717afe0335b125dfc77217cc61277be45"
    sha256 cellar: :any_skip_relocation, monterey:       "03e933f397a77a8aa200491953edd81fb710ba62cc915a1b705223a1d9ec086a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaa7707b1e2e839b3b84fc8228acb44776554bd1c3cd7d61a7ba1eb0339c4a21"
    sha256                               x86_64_linux:   "6a9296332c50fc78f32e827855799dbb9b8658cf5d0d78c7d651fb0211e687e2"
  end

  depends_on xcode: ["12.5", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
