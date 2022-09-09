class Zurl < Formula
  include Language::Python::Virtualenv

  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.1/zurl-1.11.1.tar.bz2"
  sha256 "39948523ffbd0167bc8ba7d433b38577156e970fe9f3baa98f2aed269241d70c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "cbf5027867ea9729a019902d2f491b4ec2bf06c9b6e628b5b64e761b406a166e"
    sha256 cellar: :any,                 arm64_big_sur:  "52fa23c3cda835f52109102ddc9ccbe7ed64bb1b4ac5e8d2826b2019d7b3f5df"
    sha256 cellar: :any,                 monterey:       "732931b515e27cd2e89a605a561561981c73d46606ff71e80c64fe48a1708030"
    sha256 cellar: :any,                 big_sur:        "d56d33c65d948e66b3a8cf470d8e889c301e7cf6d71972e2e5b0668962e5fdfd"
    sha256 cellar: :any,                 catalina:       "4f7fb91c8fc4f34e43faad72bd1b172c254e09a5d68cf9bd48300afab7a79032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f1a67d9c39bc3084dd751ba43dfb967d167cb93a0b636f8b953202632c3e5e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :test
  depends_on "qt@5"
  depends_on "zeromq"

  uses_from_macos "curl"

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
    python3 = "python3.10"

    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    venv = virtualenv_create(testpath/"vendor", Formula["python@3.10"].opt_bin/python3)
    venv.pip_install resource("pyzmq")

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
      system testpath/"vendor/bin/#{python3}", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
