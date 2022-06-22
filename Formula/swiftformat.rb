class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.11.tar.gz"
  sha256 "418b0b44a85005787b1bf6ce89a0660cdc2bed22768e948f13ac268beaa910df"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "954afaf9109e6930b6b7d28ead08da739fc65e3c3a627f82f096c9cdf7b8a90b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b29d7355a57eaee541286f18457bad9e24afb934e62c9f49dcf9a56c86b83078"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa46cd612b35fb97d678db2da6ba426f986b8d2549a02c55ed2beb0106679dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "705d9f77262a53336e6367083ea1554683bc402d781259ed23cb07177afe37f6"
    sha256 cellar: :any_skip_relocation, catalina:       "216167d1fe1034933900d93056f97b169987ad1e0a0b9238a2889dccc7f79141"
    sha256                               x86_64_linux:   "f00160b4eb1d370d6baf4341341f813af80ba2fcfa2e65657f96153713d1c774"
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
