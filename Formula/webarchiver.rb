class Webarchiver < Formula
  desc "Allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.10.tar.gz"
  sha256 "06705d361ebb1de6411e4d386a01a60314aa52d5c20f64603c1b9652a3eceae4"
  head "https://github.com/newzealandpaul/webarchiver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ea8cae29374c5b638bc0ef3d6041c2841c167fdcd113fc8596fe33a77f526f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01db745b1093daa64bf029a355126fabade68c7a2126f8cbec2b2db22d812628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50bf552bad7141e95abb811a7bb8e200747183486e3875524281175c83e81941"
    sha256 cellar: :any_skip_relocation, ventura:        "21bd410ab07dd9e4af041de01cdb1f0699f9565d9e3672f0b6dd17b14d39bf30"
    sha256 cellar: :any_skip_relocation, monterey:       "3525514b45d1ca489e33f62150d803354902264444ab78ecbfdbdfcefbc8c27d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25c37b0ebcc11c2e38b75f094e8772fbb5864fc5e32d67dd5d35e398f8a6ed4"
    sha256 cellar: :any_skip_relocation, catalina:       "7413d45de93fbe6fcc3bc9af073a2bb063cdad7f3479d6bf890634d48761df22"
    sha256 cellar: :any_skip_relocation, mojave:         "ffd1e97727c1551d6bfc63ba3980469ca7be4c99bbd89c1036671a1e3463e3e3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fe85ee50f8a3da76dcbcd8bb24c1bea05bde33525055c4d471c8b07fccadfa65"
  end

  depends_on xcode: ["6.0.1", :build]
  depends_on :macos

  def install
    # Force 64 bit-only build, otherwise it fails on Mojave
    xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

    bin.install "./build/Release/webarchiver"
  end

  test do
    system "#{bin}/webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match "Apple binary property list", shell_output("file foo.webarchive")
  end
end
