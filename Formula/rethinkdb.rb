class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.2.tgz"
  sha256 "35e6a76a527d473a7d962515a0414dea6e09300fff368ae713964ce2494d9c0d"
  license "Apache-2.0"
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "987be35527e8b38d14adac7f8ce76de983ace1a0d75ae45689ebaab20d17560d"
    sha256 cellar: :any,                 arm64_big_sur:  "dd7cc0284f0fe97d3e90314ba5f9cf999a2d46bf0ae885c1c5400ddba5e31bf3"
    sha256 cellar: :any,                 monterey:       "31fb40137594acac9e198d73fcab40abcaac5c743e9ea9679d64a6fbaa7ddad2"
    sha256 cellar: :any,                 big_sur:        "de667915331e34d36a60a23809b290e96a0ce3636748cde367d3a3f5aca6131d"
    sha256 cellar: :any,                 catalina:       "d6bc3dd9beaa5bfddca42ed872853813815b0ba558608612a3c676cd29947be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1681a0198b8f118040914abb46dd214783b0eec4c1d2c7230ed1bbea14b5d443"
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"
  depends_on "protobuf"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # Can use system Python 2 for older macOS. See https://rethinkdb.com/docs/build
    ENV["PYTHON"] = which("python3") if !OS.mac? || MacOS.version >= :catalina

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    args << "--allow-fetch" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install-binaries"

    (var/"log/rethinkdb").mkpath

    inreplace "packaging/assets/config/default.conf.sample",
              /^# directory=.*/, "directory=#{var}/rethinkdb"
    etc.install "packaging/assets/config/default.conf.sample" => "rethinkdb.conf"
  end

  service do
    run [opt_bin/"rethinkdb", "--config-file", etc/"rethinkdb.conf"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/rethinkdb/rethinkdb.log"
    error_log_path var/"log/rethinkdb/rethinkdb.log"
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
