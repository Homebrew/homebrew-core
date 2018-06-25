class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.33.8.tar.gz"
  sha256 "932d45b87d955aee4c9072556f065df0ec6e1516ff9cbe902bf2a07dda1b064d"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5f65bd9463728af018dc533a34c0e97a4ba8d558140385039693ce01bc48c6e0" => :high_sierra
    sha256 "4b918cf20bffa40345abc9807abf9101c1ac5ca30f0da808fe78e395ad597b0d" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
