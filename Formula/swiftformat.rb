class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.7.tar.gz"
  sha256 "5bb1e773b5b279c290845f8f7e7de04f86d1bd978a9068f23b385651fd0b4d38"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "64097d967738decbd341baa3d17017028aaf65adcf4fce3cbf8ea166c9bff241" => :catalina
    sha256 "96f820d08a8f0b9e1bd986abf792730ffa4365af822621d11780dae555d5fe76" => :mojave
    sha256 "df268070fc2ce986e6a33fcef5ecccb6aa14dff2e48f9723568ee2f43fe16efc" => :high_sierra
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
