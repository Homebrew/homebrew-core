class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.3.tar.gz"
  sha256 "d58c2e544db3d19aff48ac58d1e1773902ab40d819a464683ec65ed4599aa528"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "24c1392e19e1b4e3d26707104cfd40b2ecdbcdb10a7bca1771c81a3abfff0879" => :catalina
    sha256 "53326a9164a5de8c624f35864464d39e9379ff18b1281fcd4b7b9be78e9d1e82" => :mojave
    sha256 "444f77112ec17379b2000bb841c8e34132f9403959bfd89d57edf4a55a90e027" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]

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
