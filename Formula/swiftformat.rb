class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.5.tar.gz"
  sha256 "70b058be53b0df891fadb43a6aed3711cc56f44ce0bd32520da2a35473011f82"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "55540852cbf2df95dcfe75de14c03a26a8110d79bdab88f7bfc7fa12d42cb909" => :mojave
    sha256 "fe50d0eea4a6708ffc883a1bbcdfe73c4b3d8dbe4c605356b1ba76029c11bf9e" => :high_sierra
    sha256 "694bece5c5d9d3e0be62a49a9a2450d873ccc41ca8a2cca91331389922ce1041" => :sierra
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
