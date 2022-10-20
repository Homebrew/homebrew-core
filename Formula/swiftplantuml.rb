class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.6.2.tar.gz"
  sha256 "3fcfaded9b824115b37c627e6a7e235522bffc371bfef3c35119b5ab3207fc25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e239464c15500b77d934892b6d1848637581a51240dd43326eab217b652183"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e4fe2418e139ca0d1cda671c5acd7572d18890cb78d73139e89dbac7c553b33"
    sha256 cellar: :any_skip_relocation, monterey:       "06ce1ef56e536dd11c773e730f90796e4da8be41b3844aabb4f6ba30d34dddd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c456ca66dd30f08214b084af6985724ac2bea855d48988890d67959ba8a8d6d5"
    sha256 cellar: :any_skip_relocation, catalina:       "143f92e5793600648b794dd20f62cfdb2601ac5607d17bd8ddc8b9ddcaa8072c"
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
