class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2025a.tar.lz"
  sha256 "86882399c58693976e0fd291994d2bd8520036c303f68836197a56fb135c2815"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1371ba4fa367e2dfbc70ed6b33e95708883a5ceb5d257b55591b70a0d50dc694"
    sha256 arm64_sonoma:  "eecc3bb8f8bde2a4837f7516e837f8b422b82a8c0a17a58355415b8b255ebd8c"
    sha256 arm64_ventura: "c84286138779756e744b65e1e07a99fac1af43d8f6dc4fb4527e9d7b9de67309"
    sha256 sonoma:        "008371e4fdb2913b2de5113135bb8263b510e5fa4d14bc9aa00530697f621b0c"
    sha256 ventura:       "b64ce644a2ffd2569644cfcb8e5c580c0ddebd8c572bb282f40d4e007bb10129"
    sha256 x86_64_linux:  "95dbda0bc9df9eb64f66e913a91d049a11ea9cc2513102e24654dca5119b9377"
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
