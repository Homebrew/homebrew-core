class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.5.tar.gz"
  sha256 "15e3b7d411456c1e2de47cc1613c71bf872b01eed4c0d653ec542ac7dd674fea"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ce4fd0d4ed7a9e79c5505a2b085a8acc74021116097d2776a210d76724e72cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3649979a7461b92339c62e0360dfbc5fce2eeac62a08ef11639f89370d69e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a0ccb162f2e0e4baa2863d5f260c189fd271ddbab299c5e6c4bb33c42cbf97"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1d50fb7627c5a2e084a0a7f1e0835c1e380e41ca50c7b32f268fbdbbbca16ac"
    sha256 cellar: :any_skip_relocation, catalina:       "8168fbe08520c4555db5472355f9d1818e740356871f9a05ca47250e89b3c583"
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
