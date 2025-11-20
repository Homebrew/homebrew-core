class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2025b.tar.lz"
  sha256 "ec2f98c739009fd81a654efe2ee75069f54bcee5e0d80f510ee7e1f469ed293a"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c2735093cdf1e304a2ef21d70a0890ab65a029938c4c7b6a0859150897aa611e"
    sha256 arm64_sequoia: "395beebfd6ee0c176b652616c699bc61156e13434ce1825c150b423a51c89a88"
    sha256 arm64_sonoma:  "0038255105832e3ee626bb0df264b1319e7e78b9cad31a2abe63318d78ca492d"
    sha256 arm64_ventura: "e9ca9450eef87b08d7c13aaded06eec5c1d74e18669bef7410478c25f4d3c1ed"
    sha256 sonoma:        "a5a51679cf236bc9507f021a8242109e28d3ed819314a952b4b490bd98897b62"
    sha256 ventura:       "247d8ff7d370a6cad981b6f02ed7701552f3afd7acf6d995bd65c7da1b4afabd"
    sha256 arm64_linux:   "8043c2dc13b4519c7da6b6f6ab3cf65e54aff930fb3cdcd8946b92dd41dfd554"
    sha256 x86_64_linux:  "9d3694b504470a7c9be63ea205ee5a4a488a57f983d75ca3d563de4ef98f5e0b"
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
