class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.5.0.tar.gz"
  sha256 "2ba045c719e11d84bb8951b7e352b34e7d459318505f8fc9b1987328de598dff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f186b050fa2dd9177005dda91cbf8b092531545e563311ff9de205ed10499129"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fae22f50f3b96544982dd2183d8356c18961af18e02a922e8a07660573ab538"
    sha256 cellar: :any_skip_relocation, monterey:       "f4993e2733db57a124de7db27e31fb45aa180f2f4baf468a2960cee14d84d213"
    sha256 cellar: :any_skip_relocation, big_sur:        "1287a6c7d6928e1c2f9e2389ef2ee725608ef5fd35f9b8d2af6a4531c7622cbb"
    sha256 cellar: :any_skip_relocation, catalina:       "e6fea94225e8b3d83b11510f2c423d850a16922fe2a5c776e88a66ccad8fcdde"
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
