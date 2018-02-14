class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://mirror.roe.ch/rel/sslsplit/sslsplit-0.5.2.tar.bz2"
  sha256 "f32c7fd760a45bb521adb8d96c819173fcaed1964bf114e666fcd7cf7ff043a8"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "77fecfb100b0790546886a4aa51af7799505cc656ba2950c6d49b93801aed621" => :high_sierra
    sha256 "ea1ed69cb35e34a67e956549ce71ae3043e1ca48bb436c53d244a7cef93534e1" => :sierra
    sha256 "a772d1ae52d6e4c89fd90339ceb5f9a8739246ecb73acbf50fb292814b9ec36d" => :el_capitan
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
