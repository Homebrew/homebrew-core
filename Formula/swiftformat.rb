class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.16.tar.gz"
  sha256 "7a559b8d219eb98fc1f4085ad5e23c6105ad57e2709ec983791c2ff72f186ffe"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee1ec29380be2abf1ea1ac0e8399d7bea1990c19888cf8416789074d1b55b80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0e6466cecb29713b799bc1eb95faf1d131879cf7860119f39dccfed35e68e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8668c85ec249151ff41dc26cc7dff5ebcc71157480867992ed33e704ec5ce3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b8f2054e7aed65267ec9a7fe95baabf27a6bd9b2a3a128c2ff709e0b6f4c1fd"
    sha256 cellar: :any_skip_relocation, catalina:       "5764de72a34287e732cda39964264c47cd4b7245cc68b9e8105f259e0ee474d3"
    sha256                               x86_64_linux:   "297dbf45ca4bd27722477d0b091ed32b8c506ef53a9bc85d47937e6047002871"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
