class Sixtunnel < Formula
  desc "Tunnelling for application that don't speak IPv6"
  homepage "https://github.com/wojtekka/6tunnel"
  url "https://github.com/wojtekka/6tunnel/releases/download/0.13/6tunnel-0.13.tar.gz"
  sha256 "8bc00d8dcd086d13328d868a78e204d8988b214e0c0f7fbdd0794ffe23207fe5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d847ef0fc6b81caed85f280cc141d608d76549981701549464e23a3f5db3157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce493b1a9309acdd209d74c96eed32d4b579f2500208a9f926ac513fb01080c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a6e10e77b34c4f10e17f389b38fb3c58690c7988e8274bbe2078fdff571d34f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1635b9e636c6a40a57db5d56a3e4df68218b23b01be3e5568d573776eb6ad9"
    sha256 cellar: :any_skip_relocation, ventura:       "a0666f067478b4b5141260896b60dccf2a2eaeed3892e229eb267d44a045e0a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa9b18d88f1816365473ae8b9ccc98bfdeb030dd6a0c6d5c3b6f2dc360c639b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38f0ad3d208f1f83ba4d6bc75ddd2e5e02ab5579858ebdfe413da6da7bd3bac"
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
