class Zurl < Formula
  include Language::Python::Virtualenv

  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.12.0/zurl-1.12.0.tar.bz2"
  sha256 "46d13ac60509a1566a4e3ad3eaed5262adf86eb5601ff892dba49affb0b63750"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # src/common/processquit.cpp
    "curl", # src/verifyhost.cpp
    "MIT", # src/qzmq/
  ]
  revision 1
  head "https://github.com/fanout/zurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb2c86141ca65e087181c6d802dad72bb3d0b3ecd75286663077b29ef5ee8ed6"
    sha256 cellar: :any,                 arm64_sequoia: "6b0d185ef6601a9a7feb2712ac0b7d4242e8e35e4572cb8aca3c88109461f1fd"
    sha256 cellar: :any,                 arm64_sonoma:  "b75dbe6b4c8eb60c671c68c1adeb4bf0fd4ec011051c34bae3342ee49bb3a1a3"
    sha256 cellar: :any,                 sonoma:        "318fd22b894af157b9a54a874d13c805b1474d97a43cd50e0e39f15262472b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591a82d1ae225eeab0cd35808e860c1b69b9cf84d13ef87962aa4f0b24c0ddfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9298662889e90ecfc5078599cfeab0862621e9839b92af94a93b32b5db4430"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "qtbase"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["--qtselect=#{Formula["qtbase"].version.major}"]
    args << "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "install"
  end

  test do
    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    port = free_port

    conffile.write <<~INI
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
    INI

    server = TCPServer.new("127.0.0.1", port)
    server_pid = fork do
      loop do
        socket = server.accept
        socket.print "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\ntest response"
        socket.close
      end
    end

    req = %Q(J{"id": "1", "method": "GET", "uri": "http://127.0.0.1:#{port}"})
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <string.h>
      #include <zmq.h>

      int main() {
        void *ctx = zmq_ctx_new();
        void *sock = zmq_socket(ctx, ZMQ_REQ);
        int r = zmq_connect(sock, "ipc://#{ipcfile}");
        assert(r == 0);

        const char *req = #{req.inspect};
        zmq_send(sock, req, strlen(req), 0);

        char buf[1024];
        int bytes = zmq_recv(sock, buf, sizeof(buf) - 1, 0);
        assert(strstr(buf, "test response") != NULL);

        zmq_close(sock);
        zmq_ctx_term(ctx);
        return 0;
      }
    C

    flags = shell_output("pkg-config --cflags --libs libzmq").chomp.split
    system ENV.cc, "test.c", *flags, "-lzmq", "-o", "test"

    pid = spawn bin/"zurl", "--config=#{conffile}"
    begin
      system "./test"
    ensure
      Process.kill("TERM", pid, server_pid)
      Process.wait(pid)
      Process.wait(server_pid)
    end
  end
end
