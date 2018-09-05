class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.4.tar.gz"
  sha256 "eeb2adb189059e158a1c4f6397d1430be27c73e3f313e6cf37061d49b24d3264"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ba76e76f4d8dfe5899d0f7fcd2badcf1bd324a01f2f79065e399caffd6fc08d2" => :mojave
    sha256 "2b7176b2600f4ce1d7a63d65179d74d0a1e00ef65248fdb0300da51e97aa98a3" => :high_sierra
    sha256 "89771036d1faaab071b7b26033ae5cb08bf49ff8dd34dc74f5351b41953a3804" => :sierra
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
