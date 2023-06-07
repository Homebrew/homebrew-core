class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.10/sispmctl-4.10.tar.gz"
  sha256 "e648b6e87584330a0a693e7b521ebbc863608d6c97ef929063542b459d16bc6f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "703696c8d81d060b03eac428e55f969b20a5cb7d72ed28ede86a9460a6703c80"
    sha256 arm64_monterey: "47d8f6994c00729322c939a343d877f80ba60ce577f627c7d23f2853dea72988"
    sha256 arm64_big_sur:  "8922a63bc4da5a8253bd46bffff33679aecb88ef8753cf72223b787e9b6d8b9d"
    sha256 ventura:        "f896d3db8eaeaa158b685d466185cf65aebcfbf859fad00fffdd3d094724e73d"
    sha256 monterey:       "3794182ad8e3aaf0d17027d79f70b4c242f036ec5f96423ccbddc5eda6ff674a"
    sha256 big_sur:        "cec6faa6ed93cd4846494ed0c4e2e00972de9c74f823daadfe9020379d554157"
    sha256 x86_64_linux:   "5b7a0961b12e493dc3ac5da1ff14914cd254abf7b98049ee8c08224afb22c881"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
