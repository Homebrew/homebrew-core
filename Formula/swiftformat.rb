class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.5.tar.gz"
  sha256 "330207123ba1b482d6b1d776ea004f22811b33f19a9b7a4a1304f260b5de63c6"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "997b04cc350919b14ca765735750f68b0f2dcb9c4c91abd301bb06be48b7f250" => :mojave
    sha256 "df8f24fe21fecb69e0010d4414537df53f0af0815e6745a10d1a059108009afb" => :high_sierra
    sha256 "e2cedf0dcf1c1ab2eccc00585bee4c9d7e8bdd2a1fc70573b869dcc315eda7de" => :sierra
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
