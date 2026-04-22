class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2026a.tar.lz"
  sha256 "0913509a37f26b81bb6396018ad5cdf32065374ed36e82cceb61b2ee57a94b7c"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b54805ff391fe9ba41d6376fba4b738af0d05edc45972eb7d01ff575178ed684"
    sha256 arm64_sequoia: "4856c8e39f5eb1682762368d964aff11ab1e7983b9b6e4eb008ad1a759064268"
    sha256 arm64_sonoma:  "0f661ad753c3fa9b8424b6c55706df6170c920967831236cf7f8675fa5a812ce"
    sha256 sonoma:        "d81dedc44a736cd84842ea7024db89be0fc0f623289e8cfbdf208ca50fc6f16a"
    sha256 arm64_linux:   "96d831e960f04c43fa85fb4e16de2c8563e65d7363da5f14b43b7a8f6164453d"
    sha256 x86_64_linux:  "7400a2127adbd86c954ccede184b663df360ab4912a7ed84e785674a81aca4a7"
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
