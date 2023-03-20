class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.3.tgz"
  sha256 "c3788c7a270fbb49e3da45787b6be500763c190fb059e39b7def9454f9a4674f"
  license "Apache-2.0"
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae30957e7551311117601bde58ab4ebca32462d2d954c1e080d14caacee958bc"
    sha256 cellar: :any,                 arm64_monterey: "59858581f1766561f3ab4981d3cc9ddab96e9ff04309a5de27c9a4a2b4e7ffc5"
    sha256 cellar: :any,                 arm64_big_sur:  "896cd6b4cc6cacf34ca3cee6506b601f277c14f6aebd94893ef7a01cb7f27707"
    sha256 cellar: :any,                 ventura:        "ae34d8f985b6653bce595c4bf9ff78b9efbe6b66b3457faa853fac44def55ef8"
    sha256 cellar: :any,                 monterey:       "15280636e59a10ea79b5eed7216b98233b92843041075c6034033a3de89571f4"
    sha256 cellar: :any,                 big_sur:        "8c37c99dc3bf4ea3151fc0019e202e79645952955a9a537eed894ae9de7a92b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b283e13c64f5da913686092cb2d0de922170d13104d37a6e953e192324dc6e6"
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
