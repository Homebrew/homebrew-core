class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.14.2.tar.gz"
  sha256 "c2f82375923ae7470d04967faa390dc9d18b9d783b88dcba047bfebb293596dd"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e702504aa7d0a368b1d9706aa605300801339198fa27df151a65963a236d6c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961243384aa0da2c6013e0c11127e973a6f734c35c1a9cd2d4dbaa7fd18d8a52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db489c563202c9f9f7c24ff0dc6a0187861e0b51d56b1ef3a06bed0a5cf66816"
    sha256 cellar: :any_skip_relocation, ventura:        "c4fe74a86e322fc66fed91a19ae2ea6450e5c133987cf564f3e81f1a11254683"
    sha256 cellar: :any_skip_relocation, monterey:       "6acd8e0f63b02164c00ebb5c7fc45b691776ec0c686daa3a0345590d5da8b2d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0782650f7808912cf99a77420d1cfadb51c41f0bb27736dbfc1c93292a1d3c1"
    sha256                               x86_64_linux:   "ea85d760585470ad768ea01c55373a06b7e14e4cde928ba0a9816d718d6fb119"
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
