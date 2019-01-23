class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.4.tar.gz"
  sha256 "581d1f96bb9c989fe947c58073d56c107b9efdc549031e1cffa7264b3ab898ac"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9206b2643151f50466053b0e218031b3468e32e4abb1c60535314bd713061e2a" => :mojave
    sha256 "0e0530687183770bdf75fad2539c9f7422aa3cedc0156564904c1e4f0d7d56e8" => :high_sierra
    sha256 "6080a812acd52876eae742b3dca076a983bf1c04f1bd465529675d015298afcd" => :sierra
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
