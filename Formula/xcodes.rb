class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/RobotsAndPencils/xcodes#readme"
  url "https://github.com/RobotsAndPencils/xcodes/archive/refs/tags/1.2.0.tar.gz"
  sha256 "561a6646421cbdb37cd44f89d34647f40e6cbe643f33a51888bcf5046840b9ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2dbbbf7469ae6b790a42718ad8ad3a0a08d0f139caa7f70dc3c6528ac92a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9029b3feb389e7120455cfa942895b94878615516b3556602ff5254761b0ff7d"
    sha256 cellar: :any_skip_relocation, ventura:        "e3d5bbc993046e1f6da3ce17fb00531371128a46dae98316137ba1b64480bf75"
    sha256 cellar: :any_skip_relocation, monterey:       "2751e68b83633b2728f9939a21bafb993049ac78165ed09c928005bcff763f50"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
  end

  test do
    assert_match "1.0", shell_output("xcodes list")
  end
end
