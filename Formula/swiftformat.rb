class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.10.tar.gz"
  sha256 "1d227b966d6c77972b55b59f88ab3d7859629a8c26f29c49f958c86168ee574b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "52fadcec99e32ce8f47668c23e52e06ce1a8062003bdcf2a10700e21c15f27ca" => :big_sur
    sha256 "e3c523d91834373b22730be7758ae5d00488c70da4bae0dc698bedd24b7b1057" => :arm64_big_sur
    sha256 "dbcb5268ffbf6a972b7e438f734a586af07c1986868e440c65b27652a3f5c9c5" => :catalina
    sha256 "c896f5f8212cc2f5b14b0303c55828808abb28c5a66b2964a9a20aaa13c9f9d6" => :mojave
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
