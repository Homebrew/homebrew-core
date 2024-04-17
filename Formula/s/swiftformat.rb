class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.7.tar.gz"
  sha256 "eef18f2c7bb1ce20742954cfab7c6850fe748d86edd75cd23eba5faeaeaaa6b8"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2f7828b4e10cb516720dc4111438c24bdc5d75fc82a4a175e881e3f9439dd98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "025148f7f45c838d3d977584650fc1f3376c991c8688d85f9c378e321771d7f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d589f89e9a703083e595e5cc07bb77b60751791981552979fa375b8e4fd1d915"
    sha256 cellar: :any_skip_relocation, sonoma:         "548b6cd20200f42a800750ac2cfc9af9f98f6fa8fec6d4f276d29760abf20bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6b185a1688ffe048ad63bbd1f621720b0ecb1d2b4fc3c715eea4f708324278"
    sha256 cellar: :any_skip_relocation, monterey:       "61b6ef2a0c5f59e181a339d2dcd691b610f59f5fdc63c221b54652516eb5c13f"
    sha256                               x86_64_linux:   "085458c0b11f0a4e52389567b7e5c8d5293b28a3b1e85e1cba375ebdd0f0fbd0"
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
