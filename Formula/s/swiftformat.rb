class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.57.1.tar.gz"
  sha256 "f9481fd43ee5d85f9e4e67f221c7bcd94bec5eaf8b5d81c8978c1c81a9420138"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e14c15a8d2d2657575e53f0164e3bc22df4fa93a32e60873a30977895bb08fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8bb136a937e1e111acf26a9e0f6c4e4a2c9679345bfb8deff260bce68d6d9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eb9216c681d79835183068a9b47f9df4ea3ceb67a6d981e8c0ffb2e241d058f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1ee11aab698b371bdd7dc2a186d8c9606af5616cfc30fd94367d29c63bbab65"
    sha256 cellar: :any_skip_relocation, ventura:       "6e83a6ad12a1b74094477c67dcd188f06d529c624ed049dfbb61a099be6d8271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe3023ae783382146a8b13c4ef152f20de0433a204a10796e61bb45f6ebfd967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd5d8aa1c642577dde8fd480e36d739c490e74b2865217a0930ca9c7f2a9bf12"
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
