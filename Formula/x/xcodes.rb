class Xcodes < Formula
  desc "Command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.3.tar.gz"
  sha256 "ecc37bc69a6eb343a3c58f5edab42169bb2c4d38266b6585dbf5738d3eb59eda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24c153e54448a55cfed1f1e2d547cc714abf15faefc187d72443306c4cfc054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1adf300abc73b959d49ac48a92424fed029a4dc63d044dac05a589e97915b2b"
  end

  depends_on xcode: ["16.4", :build]
  depends_on :macos

  uses_from_macos "swift"

  resource "XcodesKit" do
    url "https://github.com/XcodesOrg/XcodesKit/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "b8b1740467752421515cc741de2e066f104c66ac0c70fc8e7676816261c37685"
  end

  resource "XcodesLoginKit" do
    url "https://github.com/XcodesOrg/XcodesLoginKit/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "d0e25a892b03c272a533f7e9ea7f9ea9f6bbd34c51dbfef1d0069f5787e154a6"
  end

  def install
    (buildpath/"xcodes").mkpath
    mv Dir["*"] - ["xcodes"], buildpath/"xcodes"

    resource("XcodesKit").stage(buildpath/"XcodesKit")
    resource("XcodesLoginKit").stage(buildpath/"XcodesLoginKit")

    cd "xcodes" do
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
      bin.install ".build/release/xcodes"
      generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
    end
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
