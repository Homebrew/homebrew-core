class Sslsplit < Formula
  desc "man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://mirror.roe.ch/rel/sslsplit/sslsplit-0.5.0.tar.bz2"
  sha256 "3eb13c1d0164bf04e7602d9fc45ef7460444b953efaee3ee7d52c357adb3a89a"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

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
