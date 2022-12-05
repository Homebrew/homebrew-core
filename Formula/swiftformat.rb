class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.6.tar.gz"
  sha256 "1ffd7df0835f207487b30f0b53635df02457dc5958f181e8d9c1e2adbad7c698"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9048ad0b39a71e79f931af801e6eeddbd6ef875c5151443dc4c48b59ab8c4504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3243f198719a5dfd8cd24ac7369d3acc16c212410e49e2d12feee08b64e75a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26f2d7e695889f5f368d5d3edd91e7fc4a31a46f12739eb634a6d4eb3cf5ab5b"
    sha256 cellar: :any_skip_relocation, ventura:        "6c641f1e6f9252e7fec9b027d428b26ebb5f4b07791bf03e014ee69dbce018b8"
    sha256 cellar: :any_skip_relocation, monterey:       "3f47854b763118a93ce59ed117a6870e79150a936c195a2c89ef415558aac2d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1cf900d6f08798351c9d0c3bac7844cb82eef6c630e518cb99c45656281264f"
    sha256                               x86_64_linux:   "1e29860c6f92f75f8dd5084a14fc40f419a6cd19af26b74f5e8ec9ef809d8e98"
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
