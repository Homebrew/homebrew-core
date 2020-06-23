class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.14.tar.gz"
  sha256 "340a7504d6e2ba74ca95192d2124f0694365277f20114629e505126dfda92f59"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "bb3ee5ee1c79b352b1dc269e4ff23aaa1b4478892347b14f98ea78cac69a0454" => :catalina
    sha256 "31dcafb185ce11748a2b56e1308f4e23a86e5d6cce82095f6cefba32370d7335" => :mojave
    sha256 "961658f0ff7f2458e1de2ba0d9d7fae6095c28836b4371da3e47fb7f3be65db2" => :high_sierra
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
