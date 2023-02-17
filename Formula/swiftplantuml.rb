class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.4.tar.gz"
  sha256 "8b8678f7a307448b3147b8fcfb09bca68ecdf124c2cc6ed7a9c2f4e8be302bde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "991717c59af13fe1b71580c08b2d554bb565d38bbe2baffc2ea115d80e1c8d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621ca72360541eff69a9ebc0fb561a8097db7f3412c33fb2a01374d30c6debad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15614a7b3b26a627a98f69ef6fae3905c42e436bb71a964371ae7235589a6d6e"
    sha256 cellar: :any_skip_relocation, ventura:        "f1892d885c8623042099cee1081f15084179b8c857aacd20ca7182b46fa5e303"
    sha256 cellar: :any_skip_relocation, monterey:       "da08ce197ccc81c898637b5627d2223f1237e1fc6fb23fdd807292ca2e5f70b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4e558914b75596956948c957a28ebaf6e04c3f20604acf68b67a1dee40bb64d"
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
