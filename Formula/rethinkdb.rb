class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.3.tgz"
  sha256 "c3788c7a270fbb49e3da45787b6be500763c190fb059e39b7def9454f9a4674f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72b8273491916ba72470b87d1c720ba14ecf911217d611bd178c33acec60da6e"
    sha256 cellar: :any,                 arm64_monterey: "c5c84f69aa7d97dd781577b3cb1b4485380ef78fe38b2706dfb8009b8903af1f"
    sha256 cellar: :any,                 arm64_big_sur:  "0a2b28e9debc607035bb95f0560d89566eea2e802da8332910a23daef0565cca"
    sha256 cellar: :any,                 ventura:        "48e426908edc78f998b71065b928795dcba3139df4dfd50bc7a7ab13e703c07e"
    sha256 cellar: :any,                 monterey:       "f214cf1e1218a07ee4a2656cddfd1e51648a876c1f152ecd1b27943a880cc31b"
    sha256 cellar: :any,                 big_sur:        "0bf444d7ad09a8625effecb7ebe807def916f4a55f82eeff34221cdf71f14e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759fd09fa49fc269b4ee299c9bdd1e446c669e5f8d12a7be4a7217cb4cccf4c6"
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"
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
