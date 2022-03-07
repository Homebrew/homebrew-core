class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.5.tar.gz"
  sha256 "15e3b7d411456c1e2de47cc1613c71bf872b01eed4c0d653ec542ac7dd674fea"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8253553ad8c6ce8550175e1152e82d80ce125fa4045a890941e1e6e915104e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d569c123783a70a2020f3b27de99eb7a17cfb393295e04d56c73b72212a3bf49"
    sha256 cellar: :any_skip_relocation, monterey:       "4203004748fbc1eb752fc9b9b59f94627a7d5cc50ec9c0cafdbccfd3deca8558"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9781aa3d22021a0dbc3f96e5d9604b1de9b269e9ce502e4a7eedf710a6aa555"
    sha256 cellar: :any_skip_relocation, catalina:       "13bf74f3ee6e5afb272cc9897cc7a660a738e30137e9be7d240cfa8c18aeb8c1"
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
