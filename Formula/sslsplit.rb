class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://mirror.roe.ch/rel/sslsplit/sslsplit-0.5.1.tar.bz2"
  sha256 "60697146d0a70dbebb7b71b62525ad2bfd1bd34434c72a0d25e3d226e5e4ebc6"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "45ea8230064fefd89104b7a17099d22f08724d0eb540c9991fd932b20ea4bc79" => :high_sierra
    sha256 "f5bbcf2a3524f7abbc2689325b683ea394cee5fefdd33b2c2453e24fa5ec26f1" => :sierra
    sha256 "fba842c20392d519abbaa05f0465cef17b7270aa67ae90cb3f8f7fbd457eea1b" => :el_capitan
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    unless build.head?
      ENV.deparallelize
      inreplace "GNUmakefile" do |s|
        s.gsub! "-o $(BINUID) -g $(BINGID)", ""
        s.gsub! "-o $(MANUID) -g $(MANGID)", ""
      end
    end
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    pid_webrick = fork { exec "ruby", "-rwebrick", "-e", "s = WEBrick::HTTPServer.new(:Port => 8000); s.mount_proc(\"/\") { |req,res| res.body = \"sslsplit test\"} ; s.start" }
    pid_sslsplit = fork { exec "#{bin}/sslsplit", "-P", "http", "127.0.0.1", "8080", "127.0.0.1", "8000" }
    sleep 1
    # Workaround to kill all processes from sslsplit
    pid_sslsplit_child = `pgrep -P #{pid_sslsplit}`.to_i

    begin
      assert_equal("sslsplit test", shell_output("curl -s http://localhost:8080/test"))
    ensure
      Process.kill 9, pid_sslsplit_child
      Process.kill 9, pid_webrick
      Process.wait pid_webrick
    end
  end
end
