class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.33.11.tar.gz"
  sha256 "8291132abb79c79e4791add76fe6995bb24f28fe74aa23fdfa2ea0c55457049f"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "07f1010f03be7e82326ddce393bfcbdcdc535021c653c2e21467a079e2556edb" => :high_sierra
    sha256 "59b35b25a7e16619f50f9eddfb398782d2fc3bb3a6d9af194fdbc383ac5aceb2" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
