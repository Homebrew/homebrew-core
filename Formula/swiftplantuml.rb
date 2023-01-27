class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.2.tar.gz"
  sha256 "55e7f6359a281059a95d51168ab2f7c568916faae64657d2a32458e3149fbe3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e85ee1d7c67cf689483a6c081dd20de591ce08d73a2ea554c24e0ca63ed5198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc134e57cc3611c9ba258863bad1160b7119fcf945550b99162b83b93b260fac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d1c60e82a49065fb29d80205ee2da1fa32637d1d48695f343d3b59e6e310e46"
    sha256 cellar: :any_skip_relocation, ventura:        "ff16cfd9bd1cf27ab248595bb389d9545b12c7915c943fc00c93f0bc0e2ba959"
    sha256 cellar: :any_skip_relocation, monterey:       "69cfa38c6a8e7967db655d331034e8c4be5b93d328bb7840fee7f7f70729a971"
    sha256 cellar: :any_skip_relocation, big_sur:        "98626c7c3c2358109007a1bde7730024ad4611e7315f0e522746d0fcd283fb8d"
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
