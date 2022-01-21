class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.6.0.tar.gz"
  sha256 "139f9bdf69e11719448508830b59d00e5215b72408f39e5b5e5e7082d75bd646"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef564d32296281bf4b3674ee5217b0fcaf497e2347d1f93594c1f9b5a952646b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2148c46c07ad55534045e8c63df02421d4a1ce142af8363223cab99fed5856b2"
    sha256 cellar: :any_skip_relocation, monterey:       "27579f76daf3875dd655f7bf2ef89a760572f8eb005209695c198b2e2460f2bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "da051542e59ca9092a8d6c3c5e7125d98b4e3460a0aa962ceace4bfebf25508a"
    sha256 cellar: :any_skip_relocation, catalina:       "46d45a618010bb5ee23febfb16b4512257a47d92038532b3212d10bc4ebceff0"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swiftplantuml", "--help"
  end
end
