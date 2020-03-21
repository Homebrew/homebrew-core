class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.6.tar.gz"
  sha256 "1e058e4dddcf1a6ea53ecbeb24da8f06c3e762c7e7e143ac1deaacccb16eec55"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "641d7abee2e702f7269eeeba861992ba71d9c2eb3a213d6d534aaf38bbbf33b0" => :catalina
    sha256 "2af85e98628027510db655b63d5ec3ad57f33b770e8b95bd12719c6ba3dd02c9" => :mojave
    sha256 "84d0810e7f49f30af01e5ae6bf129cbe9de34046b747b4469fe2f07f2aa7cea0" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

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
