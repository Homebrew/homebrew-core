class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.13.tar.gz"
  sha256 "344d45e442613c20861e191997fb46ffcd44e8fdb28b759a4a404c657a0cf90a"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e73274b7e8fa8ab2d2b9dc426f5e6ab3a631dca72441b0a252c3526371650384" => :catalina
    sha256 "5b30ff2aeb58db0aadfebca7b027eb8f9533d00e745371af45fbb39c9964e3de" => :mojave
    sha256 "c8ce9d512230e89944e1692ad04582eea261e4f2038a94a27cdb6407b1fd59d9" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
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
