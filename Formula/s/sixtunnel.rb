class Sixtunnel < Formula
  desc "Tunnelling for application that don't speak IPv6"
  homepage "https://github.com/wojtekka/6tunnel"
  url "https://github.com/wojtekka/6tunnel/releases/download/0.14/6tunnel-0.14.tar.gz"
  sha256 "6945312793079408f1ab40071cee68e70158a23560145f1d424a3eb16227f235"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ea36bb0c9a65137e00a01c1771740d1e716bbec5fcbd9d1395488ed8fbe9d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4835e877672bb690cf45d67eb1abc2d818034668b0c1980927151e1ae9fb6025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1acfbe3de474e92cd90bd4a9047f2324f5b0e2290a69dc389e418cde045d8547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4aebd48a551546f4cc6d56779be9fc64d7384eef2f64ce4cd5d6cef5b94a568"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f82314d3df1855fa85b58b14ab63196645a341e9ea7803fbd5b2970844d70fc"
    sha256 cellar: :any_skip_relocation, ventura:       "1ed4515caffc5e22a3eecd3616d3464519d25f47be499509e9023fbb8158faa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fbacca36b438381c95c88458edd9b7dcffc9bbbb0cad1b0dd92cbce113467d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f95d4c2df935b35c82ee57674400ae4a62069d73d0ac4f59a785da0dba34bb"
  end

  head do
    url "https://github.com/wojtekka/6tunnel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    require "socket"
    dest_port = free_port
    proxy_port = free_port
    server = TCPServer.new dest_port

    server_pid = fork do
      session = server.accept
      session.puts "Hello world!"
      session.close
    end
    sleep 1

    tunnel_pid = spawn bin/"6tunnel", "-1", "-4", "-d", proxy_port.to_s, "localhost", dest_port.to_s
    sleep 1

    TCPSocket.open("localhost", proxy_port) do |sock|
      assert_equal "Hello world!", sock.gets.chomp
    end
  ensure
    Process.kill "TERM", tunnel_pid if tunnel_pid
    Process.kill "TERM", server_pid if server_pid
  end
end
