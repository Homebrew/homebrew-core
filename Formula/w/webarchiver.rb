class Webarchiver < Formula
  desc "Allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/refs/tags/0.13.tar.gz"
  sha256 "bbb81adb809a2817e6febdcf801af805b9f4d3080127411e544ac00ee4575242"
  license "GPL-3.0-only"
  head "https://github.com/newzealandpaul/webarchiver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1335d4184a0607f3a7ec9c5b9e1b95d7332e7c0f89fee407219150975c78646b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "050531ce286b76faa0a3c831e5f9a070c0723b0bfe839e68f0f35f2829c34884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050531ce286b76faa0a3c831e5f9a070c0723b0bfe839e68f0f35f2829c34884"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "249899f8ee0514281af8b45bf56fb65941ead5ad3adcbaf56513b5e7eea39233"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8cb6227264b831514bb69badfc3ab0ebc70729b4dca1aecf77d3d81118b4be4"
    sha256 cellar: :any_skip_relocation, ventura:       "acab94c734634d21e854afe226e619321df5a0ba31c3435e24651cdecd7d8e0b"
  end

  depends_on xcode: ["6.0.1", :build]
  depends_on :macos

  def install
    # Force 64 bit-only build, otherwise it fails on Mojave
    xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

    bin.install "./build/Release/webarchiver"
  end

  test do
    system bin/"webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match "Apple binary property list", shell_output("file foo.webarchive")
  end
end
