class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.19.tar.gz"
  sha256 "3eff77d94cae57e0186e59194f7bdd63fd12acc9f481edd5c5fdb074a3391ede"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "444a81880cd49f31edb48a1ebb66735912815d1e467bf1e64af02abc04e380ec" => :sierra
    sha256 "5d952a6ec59018ba2b4d30ec78d90fccd70df62bb2d0187d5df8aee860f20ed8" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<-EOS.undent
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
