class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.8.tar.gz"
  sha256 "114cb224b1eec1df1eb5a60a625a49de8608557cb895b73d181981037621b98e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9188954d4994b1af6c0e0288507f0d7bfe9b00e14928e47ce6c78bc90aee0f6b" => :mojave
    sha256 "efd3a1212ccf90a4f1a3a5db931bc5b4d81549360cea7a6cc6487340453caeb5" => :high_sierra
    sha256 "438d11df7aeed4a3439a9806d6063876ee8fecc6076085000b1aa6e1d5d267a1" => :sierra
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
