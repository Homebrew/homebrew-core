class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/refs/tags/0.8.0.tar.gz"
  sha256 "12582ac9ac9330debc2ac85b78bc707206cf5b650a49673d2038074fe4840886"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00f16455dab36a781eeffb18f5332e80dc2954607727e972c652e3558526d9e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "248e739085db50c75367b72ca3be294e17e30397adfeaaa3be24c5206b8b813c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58e9576970771b41d07c5206f59018728fd35da3bdfdd305ad7ce2099d3a1eb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe1ee5a6ac9e09a11ea2c341ff2fd858b7a7fd261331380d361f4721eae4feb5"
    sha256 cellar: :any_skip_relocation, ventura:        "6419710ae1ccb8e3b1d8e2db1340840eb67fb6fbf2cf6b003da38988fbde9bbe"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0a5fcaefcee36bad32f1f8a1b08a57e34e682a7bd573005fb73bf87da73e83"
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
