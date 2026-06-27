class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.2.tar.gz"
  sha256 "67db730edd1c768f39c197dc8e8054bd22d0859de2dd96e49b525148579be907"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6467748dccf0c75cfaf3a1b98998c09e1b28728ae8830366f47215c13b5a901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aceb8d50ffb6fe3982b8d6c5a86fca489a8cc91e58150f79f10a1de7378c7df9"
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
