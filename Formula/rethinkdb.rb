class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.2.tgz"
  sha256 "35e6a76a527d473a7d962515a0414dea6e09300fff368ae713964ce2494d9c0d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8972eed8e34e8a209a56938493e126ee99ddab9c5da6f3d347a21a9ae0da29b"
    sha256 cellar: :any,                 arm64_monterey: "fccc030ebc0f477f4c1a282c289959f31f8f30e2b5322954d223f68e73130a30"
    sha256 cellar: :any,                 arm64_big_sur:  "d616d46ab6d345527d3b6365bcbd26957eda633004761f2713c1856caa3f6ea4"
    sha256 cellar: :any,                 ventura:        "622d6c5d659d0c9b3947be41f4b9ff3ff1f9e4b5d869875d4cc916d62c968328"
    sha256 cellar: :any,                 monterey:       "c232317587e1abbc9079b79cca56328d85a48bd16d4c11ea9b891c8483d84f3e"
    sha256 cellar: :any,                 big_sur:        "9a37dc48d0b88f63c4500144049f5e6bba34708bd6f095557195446d217e4f76"
    sha256 cellar: :any,                 catalina:       "69b7ab9e02b8f3290733f4cd02b8bf8b3a1cb3934c1d8680b931132346780d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0ebee5ea998c49cde2dcd9499c031fc5eb9bb1534de430906a1faad722b4559"
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
