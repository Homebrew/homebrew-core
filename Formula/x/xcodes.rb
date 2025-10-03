class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/1.6.2.tar.gz"
  sha256 "0c38a39ecd527d15c3343da9b9bc57c9f0d5217f4c9d36fc3879c3ae423b1295"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfc27a53e26ae6745593dbf7acb43f6165ddf918cfa1a2bac73666f974c7ba3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0d1d4136c44d6bce3a29a6161d91282397175b811d8346486ff281267106f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb68620e49151d770433566d23d52a2605a0b9783d0f957c9fa3deda6825cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79aea527da63cec15cc7e775b1a380f446ac096b425915e281f8dee6ba60ac74"
    sha256 cellar: :any_skip_relocation, sonoma:        "147e32b89cab5d9e267170902e4a858b00fd45f0cb8b2f2b43ae98a5c3e3a1ae"
    sha256 cellar: :any_skip_relocation, ventura:       "c374aa5034bb5d66ec537b6096318472a9f49f584e4a727647c44962fb504183"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
