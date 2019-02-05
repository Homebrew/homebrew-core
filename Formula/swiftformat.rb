class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.0.tar.gz"
  sha256 "a5d8eba27c8d8c80f735eab83c9292b4d691fe36b6bad8005d2a6d2092f66192"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "2e10ea111b300f6dfc429a9911428430b7b359443d1d4024f442019fae11d042" => :mojave
    sha256 "389adcf8bd71916b8026f956c7cb0c53b93cc50d7c56faaae96c68c63b58100a" => :high_sierra
    sha256 "ad4c51b8f382c47c3d24b8f4ed886c5867451b103bb3ea9d7c99c1613ea0e834" => :sierra
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
