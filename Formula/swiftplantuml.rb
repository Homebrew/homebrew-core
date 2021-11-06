class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.5.0.tar.gz"
  sha256 "2ba045c719e11d84bb8951b7e352b34e7d459318505f8fc9b1987328de598dff"
  license "MIT"

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swiftplantuml", "--help"
  end
end
