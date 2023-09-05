class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.3.tgz"
  sha256 "c3788c7a270fbb49e3da45787b6be500763c190fb059e39b7def9454f9a4674f"
  license "Apache-2.0"
  revision 2
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac93c27bbe23258d83f6c1898523e5854288cbdb791f6e56eee209d0d971d19f"
    sha256 cellar: :any,                 arm64_monterey: "1f148716b53dc578b1c8b7f038a6eebe1cf90cb0c6c89f471fb3d5a124b88f3d"
    sha256 cellar: :any,                 arm64_big_sur:  "2a2c3b1ad26019faf4d38dfac453d903c53aadf09c3afe01883875044b19d097"
    sha256 cellar: :any,                 ventura:        "b2468e75a2aecb02655945f06506777f77caa5e885cef5aa7bec84374e1cb59c"
    sha256 cellar: :any,                 monterey:       "5af7b252bfb89953457377aaa4e2c6436d5dcdc92cc1bb0b9ccc48ae935c72af"
    sha256 cellar: :any,                 big_sur:        "86ddd338419a615b2cfae24713003aa6ac38d4fc49d98f436d7bc3f89e9c6552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1206df51e0b22eaf0afbdd862e61fe7966990f951bfd77bf3afe47b53b6b09"
  end

  depends_on "boost" => :build
  depends_on "openssl@3"
  depends_on "protobuf@21"

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
