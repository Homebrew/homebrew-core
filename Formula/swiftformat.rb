class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.6.tar.gz"
  sha256 "3962c4fb01880587012d3532a24ae86a1cba8e9a98b99caa39d0dec221acb485"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "671ba190a79fc09b22a12f8f6e442e9d100a48bf510bc5297109952dcf63b6c3" => :mojave
    sha256 "b68c08c883424cd37bc5bc54f9a93ca416e00efb12e83a6ebf758bd4b247abe9" => :high_sierra
    sha256 "b65787bbbef8fe6f8bf6eb7dc7eb2dbe17359fc5fcd6b21359110333a72c9bed" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

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
