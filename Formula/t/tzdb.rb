class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2026f.tar.lz"
  sha256 "357829e3a16a78224d23f1ae2327704c1da1fd35f6769a7aac0682755fb9027a"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url "https://ftp.iana.org/tz/releases/"
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "44178343a80320276fd8c7ed164219a0ecae54e4e9174b85d6480bf86d1dae45"
    sha256 arm64_tahoe:       "620594aeea1cf9e1308cbed040844913150f260b55bdc4f58290c3dc4e5214d3"
    sha256 arm64_sequoia:     "afadc17f4bb2d55c65dd65baef63543af67e1bd1658b4360897fe3df5acc28a2"
    sha256 arm64_linux:       "812b56c6a5ba9c862ab7413056521f1eab3f8feefd0c1856e8a5c40d875dc956"
    sha256 x86_64_linux:      "9c2729129ebd06d7557e311939dd0400e10f16dd959729aca87113917f848f2c"
  end

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    make_args = %W[
      CFLAGS=#{ENV.cflags}
      USRDIR=#{prefix}
      TZDEFAULT=#{etc/"localtime"}
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
