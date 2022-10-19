class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.3.tar.gz"
  sha256 "ec7dd4f0ac892f99e174ea952a5395b2649c337670f7dac0a5b871fd741073c1"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8170d0f3644b4544ddd17f190d920ebc1579c66b7aa475992b12767e586d6da2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b86a06f31c5c18f622ca3e67abbbbec1f613886a0685ccc40a122390f0dfe629"
    sha256 cellar: :any_skip_relocation, monterey:       "b63e2ad1d09fbdadd5c52b37392dd42e963c1ad449929fe5048daf5e15e142d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aaef13f6909ae1a61e52fc6b5ea06d4d67e2b3a455d155a496ca5f7de2e2ec3"
    sha256 cellar: :any_skip_relocation, catalina:       "a92707b7d3d9590d76eb8f6b94b794c355afbb2eec1220a438ed08d2b65db1c9"
    sha256                               x86_64_linux:   "6aee41887873254919085328bce646a1c78d307b59c73249c61462cb7e4358b7"
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
