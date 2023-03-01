class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.0.tar.gz"
  sha256 "7075c054014666fb5cc60c67b9dbb6cd3f79e2558804b9725be9467b2db23c46"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd2f9e108c5485c1f2d0d89ef202fcafa50c09fbf64566430223e40648d1aee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ab8dbd40435f845b59d8d040d7795ead5e4faac82eb1eb8e660f658f59aa51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e7cb8b7c30422f4277513ab362f95b7010a02ab4d08ae2be9b159d97ad97833"
    sha256 cellar: :any_skip_relocation, ventura:        "deaa35f99636e9d2e5df80d8f638291eebaf53750ec3a0b2c6ccca7ebe75f5b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e1ff4c783890b9b372b37f086b728a58783ce8f20f9db2cd34c89cd7e5baad8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2b8e64088220c937d50a6fad24daa490f04372cd5258dce7922fc9f6fcefbaa"
    sha256                               x86_64_linux:   "293240d2b38f2ad02e4221c55895812774e78825bf9cd3e9b39a50c4c602e8d8"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
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
