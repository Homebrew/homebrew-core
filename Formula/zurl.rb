class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.0/zurl-1.11.0.tar.bz2"
  sha256 "18aa3b077aefdba47cc46c5bca513ca2e20f2564715be743f70e4efa4fdccd7a"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d4252a3968cce4e2dbb442c16e9ceac0f917ea44f6fe29746fb62cc7b7fdbd36"
    sha256 cellar: :any,                 big_sur:       "ec815b28c14380cbc309c11fb2becb4e0421b3d933dfbe4f3b881941b97069c3"
    sha256 cellar: :any,                 catalina:      "2d34fd92311ba6e171d3bc3a5c567daa4238a0d06e0cd078c79ce4c5368890a3"
    sha256 cellar: :any,                 mojave:        "21b2977646141c7d191a9f835c42b70eff3e793b799228386043ac62ae44a34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c074c84d46a1310585b97afbb7f039fb427083d69182f959a07c279acd696a"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :test
  depends_on "qt@5"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/86/08/e5fc492317cc9d65b32d161c6014d733e8ab20b5e78e73eca63f53b17004/pyzmq-19.0.1.tar.gz"
    sha256 "13a5638ab24d628a6ade8f794195e1a1acd573496c3b85af2f1183603b7bf5e0"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "install"
  end

  test do
    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    resource("pyzmq").stage do
      system Formula["python@3.9"].opt_bin/"python3",
      *Language::Python.setup_install_args(testpath/"vendor")
    end

    conffile.write(<<~EOS,
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
    EOS
                  )

    port = free_port
    runfile.write(<<~EOS,
      import json
      import threading
      from http.server import BaseHTTPRequestHandler, HTTPServer
      import zmq
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write(b'test response\\n')
      def server_worker(c):
        server = HTTPServer(('', #{port}), TestHandler)
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      ctx = zmq.Context()
      sock = ctx.socket(zmq.REQ)
      sock.connect('ipc://#{ipcfile}')
      req = {'id': '1', 'method': 'GET', 'uri': 'http://localhost:#{port}/test'}
      sock.send_string('J' + json.dumps(req))
      poller = zmq.Poller()
      poller.register(sock, zmq.POLLIN)
      socks = dict(poller.poll(15000))
      assert(socks.get(sock) == zmq.POLLIN)
      resp = json.loads(sock.recv()[1:])
      assert('type' not in resp)
      assert(resp['body'] == 'test response\\n')
    EOS
                 )

    pid = fork do
      exec "#{bin}/zurl", "--config=#{conffile}"
    end

    begin
      xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python#{xy}/site-packages"
      system Formula["python@3.9"].opt_bin/"python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
