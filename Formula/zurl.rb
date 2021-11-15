class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.0/zurl-1.11.0.tar.bz2"
  sha256 "18aa3b077aefdba47cc46c5bca513ca2e20f2564715be743f70e4efa4fdccd7a"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "baa994d175a8df0404ac2c339f649091a658689e7e5b08501a3544301b088892"
    sha256 cellar: :any,                 arm64_big_sur:  "0b629c44e50c0201831a7569231c1348c42e04d1c1b1a39471e07ca21a7a94f6"
    sha256 cellar: :any,                 big_sur:        "7ab970b64ddfd5eb6eb78ba57b4bca38183ae9a2e41f5e1dbd9756fe5ba6c0d6"
    sha256 cellar: :any,                 catalina:       "75a40ac25e819049a6b58c0372e9ee6e5649afb3cce9f9c8ae41e24950c3b689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e74950b3dc104bd30ec4dc969093d22bcc73efdb42758371eef56345b87f98f"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :test
  depends_on "qt@5"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/6c/95/d37e7db364d7f569e71068882b1848800f221c58026670e93a4c6d50efe7/pyzmq-22.3.0.tar.gz"
    sha256 "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c"
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
      system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(testpath/"vendor")
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
      xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python#{xy}/site-packages"
      system Formula["python@3.10"].opt_bin/"python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
