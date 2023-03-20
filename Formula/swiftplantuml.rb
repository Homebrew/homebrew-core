class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.4.tar.gz"
  sha256 "8b8678f7a307448b3147b8fcfb09bca68ecdf124c2cc6ed7a9c2f4e8be302bde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b3d42ef1578e67cfbca58eccbc3bc1f88ca2bd869c734af081e3087caab5a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2279239ccd2da1c6b183d2acc7b288c13d3d61697b8d1a5d3557e7871704a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "debd729d8d5138645d61b30b74baae1b6779ac5213d77ee86e61681d3fa9951d"
    sha256 cellar: :any_skip_relocation, ventura:        "17b30d7872d734606f330585b96164eeeff4f7134a90904aaade1d29fceef158"
    sha256 cellar: :any_skip_relocation, monterey:       "19303b80ce22e8ab6551c246dd0a9cfa74390ff2a1323cee06ba838f854a3799"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a29cbe87015344d9233d5af09e6f8a537e9d6cd0b5b946042bea97fbb8415a"
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
