class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.5.2.tar.gz"
  sha256 "3c785f7f4095d40be9749e0bb717268a51015e4be0a44dc81e5d3e01902dbf7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c96aab6e49f287c653a88512ed420205287898ee6719130210d8c885ef97f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3e756fdbf10e1538d2717d2839394b8bb6f750b5f02d5cf307dfe1de529cbdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a4b4cef3f67034f8d49542da3693583d920ceee3028a1eba6c77eeeab9327f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c49c3ba9e6b91584a1896b394b2573eb92bca43a5d69e5c861e0e291912764c6"
    sha256 cellar: :any_skip_relocation, catalina:       "84d025a7d4a121cd9244dc7f237bb4b35888f11bc8881b5dba079ec588b227eb"
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
