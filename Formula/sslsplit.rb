class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://mirror.roe.ch/rel/sslsplit/sslsplit-0.5.3.tar.bz2"
  sha256 "6c4cbc42cd7fb023fed75b82a436d8c1c4beaeb317a2ef41c00403684e0885dd"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "71e977bcad186b97a787fee8a9eb1be8a9358436301ed4f3a2c815d99b58bc0c" => :mojave
    sha256 "b91c12d10cf84faa52564da27a7cafa9d3daadfb0d957e10f45155e607322e1b" => :high_sierra
    sha256 "f739a780837ce81ec5664a0fc83da5b8889b45e686f30eda81b22a279bb19022" => :sierra
    sha256 "9ec2a8e64aace6cb71390916b05f49f8b94eab5c59df7f94a0e3b902c585cf55" => :el_capitan
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
    pid_webrick = fork do
      exec "ruby", "-rwebrick", "-e",
           "s = WEBrick::HTTPServer.new(:Port => 8000); " \
           's.mount_proc("/") {|_,res| res.body = "sslsplit test"}; ' \
           "s.start"
    end
    pid_sslsplit = fork do
      exec "#{bin}/sslsplit", "-P", "http", "127.0.0.1", "8080",
                                            "127.0.0.1", "8000"
    end
    sleep 1
    # Workaround to kill all processes from sslsplit
    pid_sslsplit_child = `pgrep -P #{pid_sslsplit}`.to_i

    begin
      assert_equal "sslsplit test",
                   shell_output("curl -s http://localhost:8080/test")
    ensure
      Process.kill 9, pid_sslsplit_child
      Process.kill 9, pid_webrick
      Process.wait pid_webrick
    end
  end
end
