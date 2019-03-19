class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.3.tar.gz"
  sha256 "b731e7c8e7feb8228d4306fc388eb1220d941e22ad8f49d041d7d36e78ff83f5"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ef890bb660aae14cd1a7d0540ebc6e20e5823cb3980fbeef39c2ad446b98feb6" => :mojave
    sha256 "a66c9b9e305f89ff99ca13340bcf92b1ada8a68eb8a0bca5cf6ee0a85db283fb" => :high_sierra
    sha256 "20bf2f996967537b729981da9ac06c06d7a40b4f56dbcc2ff62a051ad8819c7b" => :sierra
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
