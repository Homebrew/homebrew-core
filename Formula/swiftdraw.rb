class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.2.tar.gz"
  sha256 "f9a13610b38b7eb78112769fa94cd79466b10a532261c383adacbe438c20e83f"
  license "Zlib"
  revision 1
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f95d453508270539da6af86ea47f2bc6493aee2f776cb8c2a2ab2a2d0d9e0af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8546420c4b714d33ed403874e528d3d3c7bf71f28ee975a7cbeee52a8f7adc74"
    sha256 cellar: :any_skip_relocation, monterey:       "90afabb16780e38bfcd45af849ce109561da56afb444b8f021fa2bc23604fa7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffd0df423c90c1f0768df5234869e0da05486d6397d51bd46ee49a06557126a3"
    sha256                               x86_64_linux:   "c2624b9959c228a26ff122663131393048001e4f45f8f46e42047bdb5b22d825"
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
