class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.30.2.tar.gz"
  sha256 "aac89f3f66b0a8f9ca683e368a2df29b1f45012c3bfb1a5523adb94e45e526aa"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "247795a05c925199b21dd4b357d6dad5f99caeb4a9f48989bf8d0a866b09aec0" => :high_sierra
    sha256 "3993cf46d36b6b6243711663c2088da7ff8a33ee8e67028e5545675c63ef6996" => :sierra
    sha256 "cef711daf1e2067093e24a3ae90c0666105dbc67d58b68683da0271ba3516051" => :el_capitan
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
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
