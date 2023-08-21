class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.52.2.tar.gz"
  sha256 "1abf451750e2d4c03aa438f062c8bb27b11adcf610a2061c80e0845255bef3da"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "365be8eeb9ac865a41f06e0a42934fff1ab9a4c7d4eeb425542188c8af523ecf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19fed428d1201e6211c687604982ce288d4b87dd7ff4da1fd5db01efaaada8ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a410d04988d771f4022b910e3d3a68429d4cd91e402d97885a70999fc5dffa7a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e09bc4b333edebebd6eb01d5e5a7d370b1f252933b55da5ab2b1c6755c7dd57"
    sha256 cellar: :any_skip_relocation, monterey:       "cb38dffa5947928e8f84b70cf280d63f1d740a4ca46c7b91764cd88582acb57d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03cfd926f3ca6dc5e0851d46def2fbb9a1639a197bd9ab5f8108064d6e40621"
    sha256                               x86_64_linux:   "601170208546fac087ed96fa9fdddf26e46b5e45bd10a8bfa3248fbe4480a09d"
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
