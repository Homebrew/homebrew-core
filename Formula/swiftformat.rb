class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.2.tar.gz"
  sha256 "dd05e44973561e0346519a59ac3e0f94b978f1502025629ef572b5e3f0c497d6"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de63c58ed65f204c5ebbdfa9f08585e19783926553742f1fe2a0bbf10a0de60d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "397e0c4d22ff8bdf94130eb14b134c3904c16ace6d6cbccc7fd5e2b640bb0d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "b95e3a60ff6906be24b528880f1fc0606b083ce4e019b1b6a173eaec0a0dc59c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c480c7425aa5d6668ab3d0897d9928f18cf25c984d99c07f9d0e634db17ea1d1"
    sha256 cellar: :any_skip_relocation, catalina:       "ff7ba2785d42107606c99ba4d6f64eb814182d12d793edf3f62f58d82cb9fc63"
    sha256                               x86_64_linux:   "05d92a46387e9df542fbd4f11903132ba503346c7772491ab437eda947d9f45a"
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
