class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.6.0.tar.gz"
  sha256 "139f9bdf69e11719448508830b59d00e5215b72408f39e5b5e5e7082d75bd646"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91ff65fb66365000964a08f29e1cc51e76ca7124d17f677fd803d42d37f23c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6018052d90c21a27b3722376a777d949c520bd3353893ac93586cb944cbea70c"
    sha256 cellar: :any_skip_relocation, monterey:       "c28a5224ffe64f87452d370ffdc89ece794d962fc9f5d2357d734bdc3ee9fa6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1659a42622d0699fa3b98d6252e730b433e0ac7dfff7755599e0b0438d6771e"
    sha256 cellar: :any_skip_relocation, catalina:       "852ca97b2716669d43da82b64cad721c3c5c1e2f53f77d4fb2b8c2a50e5eb08e"
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
