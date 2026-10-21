class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2026e.tar.lz"
  sha256 "4e9c4e9d4587443e716ed42a7070466c1e5975938fb530244a17cf6db883990b"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url "https://ftp.iana.org/tz/releases/"
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "b83eaa22c355d6fdf537abea80416cf2a2faeea9caf9abc889a5559d0f0a6483"
    sha256 arm64_tahoe:       "b8d1a31f7357e2f9d2bbfbf09afccc83cd16ab1503fd2a16567cf1b322c50791"
    sha256 arm64_sequoia:     "da20a09f521aa66c21e118262e54e7a32b0bc0a2226408affe6786189eb1a0fe"
    sha256 arm64_linux:       "000ce740c7f20659c6d69312b2acf6bf8e7185f3d2e9733d457431b44b67f368"
    sha256 x86_64_linux:      "67476d58f229c99b4235ea44e40967e86ca82f88dbbab7e07846a4095035e283"
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
    make_args << "LDLIBS=-lintl" if OS.mac?

    system "make", *make_args, "install"
  end

  post_install_steps do
    run "zic", args: ["-l", "Factory", "-p", "-", "-t", "{{etc}}/localtime"], base: :sbin
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end
