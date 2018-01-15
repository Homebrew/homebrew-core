class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://mirror.roe.ch/rel/sslsplit/sslsplit-0.5.1.tar.bz2"
  sha256 "60697146d0a70dbebb7b71b62525ad2bfd1bd34434c72a0d25e3d226e5e4ebc6"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "2cc3c67c865f3603c6bb07c5d2a07167c79b8ff86e5e106127b25e75b46483d1" => :high_sierra
    sha256 "16a00fe728b7f0d3d216448f7a96b17d2abd5def2d60d178f8b63d3fd868ad18" => :sierra
    sha256 "36985c068929da7ae9cf59f43f2735d2694fb6a6c9e0a231afa57b9b668b52e1" => :el_capitan
    sha256 "f309aaeb4016c79b4b6b59833117336784d715a0694959c2731be9c9163b5ae2" => :yosemite
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
