class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.1.tar.gz"
  sha256 "c7cb465ff97c46ad48f32a2ad5baa5a61a076eaa0faf6d5d4e44ae5aa38494b2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "07c72ee82ff59ad84a4ddca7dea83ac94ba76c29758b9602f9afb478213e3bc2" => :catalina
    sha256 "1650e00f1ba45795d397e12332a82e3a5926f184ef19d217b680b281e1e30565" => :mojave
    sha256 "e7034ee588615738dac8a9b2ebeb2dfd2ce58e1c59b51fb869ebb9cd2b30442c" => :high_sierra
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
