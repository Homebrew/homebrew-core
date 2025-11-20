class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.6.tar.gz"
  sha256 "7988bbccd9633089ec599bbbc5ea8ce12afa97e8851935d5cf54ef0b67e87140"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c49d73eca5f18ae74fba97e1c7c6291df3b4c527a3fdb66d3e6d5602e17a0983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b096bb9052efe873428fb9d48d33c2a9ca7b167a7582f50b971c340cf7c57ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e31e54f54a08f1fd28ab01252f56222a770e885858ecea86363cddf6bb533580"
    sha256 cellar: :any_skip_relocation, sonoma:        "e44590e8f0ccbacfaa8c7db25f48bde3f6943050859eecf320bb8636e4cb7c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294cf31d96f7c6b7321cd55c96138cd2ff4b5e3b32db872a5b849cb58d290864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dca6440c923b4fa14797ff4982efe88aa2d453b47ab5e123637d0ca2e1cda98"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
