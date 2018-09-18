class Utimer < Formula
  desc "Multifunction timer tool"
  homepage "https://launchpad.net/utimer"
  url "https://launchpad.net/utimer/0.4/0.4/+download/utimer-0.4.tar.gz"
  sha256 "07a9d28e15155a10b7e6b22af05c84c878d95be782b6b0afaadec2f7884aa0f7"

  bottle do
    sha256 "c81c54c3cf3a208bffc2971136b48339a0d86ae78ec0843b1d62e4342621b0bd" => :mojave
    sha256 "5b16fba957c604780f67e530d2d6d794072087a1efd8c9926b45a7bcfb81033f" => :high_sierra
    sha256 "83857df76553031baf373cf3c8d0124d5d7424bd9d42b2860e7fec530e6e91ca" => :sierra
    sha256 "d7a0ec14fe3d04b314cb0c6c9e5d70b6f72d2de02e4e3227039919551eb118a6" => :el_capitan
    sha256 "6009a679cfedeecb55dbdf0e952bc2b09a7c292f8aba5d6e861072139e2a8a23" => :yosemite
    sha256 "a1841baa5d50002615efb07d07d5049e5965c06099e120f71654eec83dd4f1a3" => :mavericks
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Elapsed Time:", shell_output("#{bin}/utimer -t 0ms")
  end
end
