class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.12/sispmctl-4.12.tar.gz"
  sha256 "e757863a4838da6e1ca72a57adc5aca6fc47ffbddc72a69052d8abd743d57082"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "de0d97fb734c7e84c8cf6035079379103a41120cf72687594db4726f6185ea9a"
    sha256 arm64_sequoia:  "4550ae3f2066c6806e0f0805feba3128544530eec07f0a5c50bf95e24d9e2454"
    sha256 arm64_sonoma:   "583417f1421c804a4c9f8bfcd9b07da96206bb90f37bb9c7983b3813a5700f25"
    sha256 arm64_ventura:  "6f9a22d3ada050881c644cf1191f0bd3b102949428169c1ac27478ed33b343e8"
    sha256 arm64_monterey: "aa41c0da8beb340c22c9eadaadddd5af20dc05fb4e6efdd2b86e10118d4fcef9"
    sha256 sonoma:         "5654736aa9565141c0001e8899824850dd817b5e229714282e9cdd5911ac273d"
    sha256 ventura:        "7320a88ebc435a780ec01e5797b39d447831492c4b342cced542c822cdb65440"
    sha256 monterey:       "08f320dfb6ab9d02451a687eedb317ff456144188b8a5c546d38e5335b71de47"
    sha256 arm64_linux:    "e4c1c91aa8aa9aca6a6faac24a61b615251a38dbc5c081381fea98797e80c41c"
    sha256 x86_64_linux:   "db43f15862bbace1e2af6f17b257da7d3522011d82f00fa581d78fea1faa47db"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
