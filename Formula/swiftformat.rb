class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.7.tar.gz"
  sha256 "141e345fd654997bcf501d085be915e2e5386e8d00db08c4d53205c2438ff117"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8e1fe019fd98a5cb6d75e31130eedcb65546693eb385a06948b940da7125d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "916c5eaf7600aa9a6bf7fc4d3998b1b165b5b354de260ce6e13bbc4ff3167ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "8ddd11b5e105b148b8919e9c44d851e845e9c31ed7cf8a9b92b2369bd0df98d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1fd4ae18452ea62e6d33ca0554fa4df5f646a22abffe7f5d489c397945b7ea9"
    sha256 cellar: :any_skip_relocation, catalina:       "f1ffad5c8bbfe80659f51b7cc54062c736fed1ff79b71b8f648d8e4552d8b752"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
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
