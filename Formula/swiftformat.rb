class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.0.tar.gz"
  sha256 "fc4cefa18b338223aad4ae39c0b7f5954a14f06dd4ca126556262b5d0b50acdb"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "81431257faa84ed092b02dbcaa5703e2759d915cb18c3a7c8f663311cbd2d79e" => :catalina
    sha256 "af859141fb9f4ecf149a4f905cca94381fb64aaddcb3a113b0f1ff1fe5d9e5b3" => :mojave
    sha256 "6842c5c972883b6c176cf02fa8dd12b09663889369b1c9ef18201d594120b642" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]

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
