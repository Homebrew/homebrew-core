class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.18.0.tar.gz"
  sha256 "f29bfb19f1c89f1aa5b7eb15debd392d73f5617689c4acfba90b836eef5fa490"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7f0ee96703ba87dd8880c105114a3666905cdb704bf327cc8eb2ecf959b2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "718d6422fbdcc3d444fb9883617e4fdf7805871e507b59bb9f58c316cbe600d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5c3e1505cac0018c4d17961f756390fa864e82cd5cba6ae8cf92ff16ef5e283"
    sha256 cellar: :any_skip_relocation, sonoma:        "4273b444e58637da174c1ab43dd17c51aba2ff706cdb014b1c77e298bd7d9f29"
    sha256 cellar: :any_skip_relocation, ventura:       "90c0dd797fe9154c5c4a51b0442eb4902c55a58a4a5d9d8c3a70feede6dc9462"
    sha256                               x86_64_linux:  "ceea5e28f0b5b603b4961f4c72ba97b462a582d0c8ae7f4b0d032712f8ec28fa"
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
