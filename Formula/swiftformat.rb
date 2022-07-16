class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.13.tar.gz"
  sha256 "cad01fadd557bc256e89204eaf2329129e5aa72b965c9d286753043ca71cb9d1"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56755b2ea97df33bab5f781541d66efec444c7c1f22b5aec77f32f5fbdfc7d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "196f59917e3dc5781edc0bf1af3b0c0b44f2b82f33998158e8bff6ed27082825"
    sha256 cellar: :any_skip_relocation, monterey:       "36a8dbc120dee0ab726b3de0b15bcc4765e3bf66eacedc32aac500bfff2b36b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "97a236637af3eadf3b3f04e06644a45e81dc9955bc458c82968e509dc2eaf2e0"
    sha256 cellar: :any_skip_relocation, catalina:       "bc9cb3a49f400d759d0228c3ce4e28b33fccdb1c5465c0d9535ac4a185b1b111"
    sha256                               x86_64_linux:   "59d7e20fc98ea2f0fdb622469d0684754ad8f14d7abd23a704f4087169de471e"
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
