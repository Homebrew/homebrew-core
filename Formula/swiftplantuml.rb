class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.1.tar.gz"
  sha256 "4b4725d0bdd26bd12c1bb4fe1e101b1d75921208bf0a97aff6d5936fed5967bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b60acd2cc0de576dff6c533234fd479ce0d490d66ecc2bd6b6f3a6116a8f8097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db2ce18037cffd29a3fac1670f3cbd97718b10275b7bd818fafaa66a7d604005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3ee0031c3e55d0862084e137315baff5378ddb7d69fde605aae4e940d1d8004"
    sha256 cellar: :any_skip_relocation, ventura:        "b38fa85b22889cf37186242f6bd2ddbea1a247e536d4176267d7889740b548c9"
    sha256 cellar: :any_skip_relocation, monterey:       "a67b36ee7df9136c6cd5d6b9fe89720d18688738566d82c788d11fe769ab39b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "133b8220e0ca1a04b56507026d20fc00c43be05cb4be929d0f7dd56d40f725db"
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
