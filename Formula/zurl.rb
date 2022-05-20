class Zurl < Formula
  include Language::Python::Virtualenv

  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.1/zurl-1.11.1.tar.bz2"
  sha256 "39948523ffbd0167bc8ba7d433b38577156e970fe9f3baa98f2aed269241d70c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4f20dfa4fa21116538bf6150b3ed05fb8e1ade026fa0a08b67d00f033c13de1"
    sha256 cellar: :any,                 arm64_big_sur:  "dbe3e4510bfb54034ca28ad3eb228314d9bde1c68e666af0c76b7676136c105b"
    sha256 cellar: :any,                 monterey:       "10197ca2f6b2b2e783781b0e33800f76c3a17d05cd423c19c228113c3b7d074b"
    sha256 cellar: :any,                 big_sur:        "156dbba9a7152ab28f5f70670de6692857c7910a00449e7040fb7ae89431a08c"
    sha256 cellar: :any,                 catalina:       "5d251122a34705e001a53b33539895698a31e8aad29a3bf7e0c6eaa3579b6a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b83d6978ef49ead8934309eb8d3db989e849479bbcc0eb695f80df53a460db5"
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

    venv = virtualenv_create(testpath/"vendor", Formula["python@3.10"].opt_bin/"python3")
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
      system testpath/"vendor/bin/python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
