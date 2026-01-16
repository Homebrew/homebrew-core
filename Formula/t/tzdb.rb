class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2025c.tar.lz"
  sha256 "fbe5b52a151c992c1aeb49bc6ca41e170ca9f8d3fb810ec459eeb79c82d6972b"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4aae720adb4711acf73425471f2dd4defaa5db9c344856019a66873985425265"
    sha256 arm64_sequoia: "0f649e87092c612e65806e9b5670f8ae8c5115d33d809909bc290da0dbffe662"
    sha256 arm64_sonoma:  "f6bb4cac3d8bbfcc66fda639664b74ee25b174bb648b559f332f72b9a1fb403d"
    sha256 sonoma:        "d618dbcc4df9cd9c8d500a786a30e4521ffdd4dc1c07d99e65d6ec5a87492e3e"
    sha256 arm64_linux:   "51c328c78de6882b81356ac916e91c7311447c79ba9cd77b855a817d77417f13"
    sha256 x86_64_linux:  "dd152213174ba906fe7a43edb3accc22236cc8748c2134a442dd6eb23c6d9b5f"
  end

  on_macos do
    depends_on "gettext"
  end

  def localtime
    etc/"localtime"
  end

  def install
    make_args = %W[
      CFLAGS=#{ENV.cflags}
      USRDIR=#{prefix}
      TZDEFAULT=#{localtime}
    ]
    if OS.mac?
      gettext = Formula["gettext"]
      make_args[0] += " -DHAVE_GETTEXT -I#{gettext.include} -L#{gettext.lib}"
      make_args << "LDLIBS=-lintl"
    end

    system "make", *make_args, "install"
  end

  def post_install
    # Generate default localtime, from Makefile.
    system sbin/"zic", "-l", "Factory", "-p", "-", "-t", localtime
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end
