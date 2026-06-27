class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2026b.tar.lz"
  sha256 "ffad46a04c8d1624197056630af475a35f3556d0887f028ac1bd33b7d47dc653"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "188a42b6866b37225f531f3d9d931787191e28640950aeb8a265f92c1fd7ac87"
    sha256 arm64_sequoia: "d99be93f4230be1623d7f1273d7b3ad6bc7b687e1f41b7cffae3318d8c57d76c"
    sha256 arm64_sonoma:  "5aa29fc8c632f83d087c4fe2bcb38c80f134114239d6f3060706514d555e770a"
    sha256 sonoma:        "f45e695ec9f10b7b67facca7fd82bf32e948bd6ec2bde78a2a4381a219f08320"
    sha256 arm64_linux:   "70ffac1bce34b9d08ad537467af7ceb7a3b050d5846b566df0ef9a62b4c5f047"
    sha256 x86_64_linux:  "5567d8846cd63a35255b7da4815f1f82dbe01c116eff53db061b2bafc70c3bcd"
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
