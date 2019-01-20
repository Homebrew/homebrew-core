class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.3.tar.gz"
  sha256 "2efe3979f73fe4b47443a5e66710c44b7d60876393eb43c686eb15e4d383dc3e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "f93cf5e329a71a97a862e6061b150f203832985f59e7c67441ed48abd7fb6bba" => :mojave
    sha256 "8205e10b9c344c3dd975016041879152acbe8784ab9f9fc9c35eaaad3fa3632c" => :high_sierra
    sha256 "3414d24fc85a7892d53487886b7eb513dc7e94c3ddb764b12c655b2f0dcf717e" => :sierra
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
