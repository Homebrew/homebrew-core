class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.2.tar.gz"
  sha256 "f9a13610b38b7eb78112769fa94cd79466b10a532261c383adacbe438c20e83f"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cad413434c51b3461b665f40905f42a1940ed432b3e0331958611c9c3804278"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23cc1195ebdcb85448108b5ace97d2fb0c9f8e71203a0ac4809ec54c5e6b2fa8"
    sha256 cellar: :any_skip_relocation, monterey:       "44f44b590301cecb9beb89f7b6705126bd4b0ef15981fc81237382fdbedcebad"
    sha256 cellar: :any_skip_relocation, big_sur:        "78364cb7adc926a6121b65f14e593a93ab555722307e75d86f9b7b25858fcd7b"
    sha256                               x86_64_linux:   "895d6010a04e68686418312cf79ce2cc3ab5da9dcb2359957c7cc48aa79912b2"
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
