class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.29.8.tar.gz"
  sha256 "aa0a50b7200504703adb37b0adbbf3b7de2bf354478921e742acffc940dc246e"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "736ff7a17b9ea20e10afe38446be0323d967539a0fc3c384d61e6760354dd520" => :high_sierra
    sha256 "5603d9d6b0c262080b40056bb5e2f12615ea4312f5b747ca1b60286729b7d1dd" => :sierra
    sha256 "72f23b62e3d2e332e7f3cfe6738ae575beafe0ebb711e03202d543a9500cdd8f" => :el_capitan
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
