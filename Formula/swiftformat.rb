class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.6.tar.gz"
  sha256 "7204f717c5bd58ea83759038d97a4ea765ccb31b34a88e88791a6515d6c9f6bc"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a684a6ccb9892d1382a6682a67db9b6c4e0db50f3e401aeaa4bd9bd2c17870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7308dba4ff65f6c4b1516ec8ac3c207d38e8b88fedcb29baccdf606748b9b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b80beeea8dfcce222aa998aae8431455644c607dca36ce9deaa23ba862239dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "922f21c82c873425d7bd6064fc7b01c29a6fb9cc327ec0ac2aff6d65944f007c"
    sha256 cellar: :any_skip_relocation, monterey:       "b0fa51fd3bff14854aea1c7be41dbecf4b11b229e8133eda6a61cc5b8364c1f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a27afde79eed546acaf429a8489f9195d6633e21259d9269bab919d32e9b4223"
    sha256                               x86_64_linux:   "306d7ebf95846c3bccc426ee62915b73566ff3ea7e0fc859624c11b0dec817f2"
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
