class Zurl < Formula
  include Language::Python::Virtualenv

  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.1/zurl-1.11.1.tar.bz2"
  sha256 "39948523ffbd0167bc8ba7d433b38577156e970fe9f3baa98f2aed269241d70c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d61f6c9edd6c3dde53d2d27e60601facce836bdee497c72335143695da6ebfc3"
    sha256 cellar: :any,                 arm64_monterey: "2efcee057b489a77051a02f057aea00f0834817816adb4d2142fef391d32054e"
    sha256 cellar: :any,                 arm64_big_sur:  "97675f8113bb55f7580ea2486545460768a82116a593947fff9966ce6bdd32e4"
    sha256 cellar: :any,                 sonoma:         "c25591faeb9c1a0140b9527c0274772be698cbf90aa5023ffbf9bd9e6c9df246"
    sha256 cellar: :any,                 ventura:        "9cc2298a117300f4763b2de6a4952c4792e04af85321ae25002eedb7eee81f59"
    sha256 cellar: :any,                 monterey:       "d5cf6cd530015d455a5f58dbf1dfe4a539e11130fee073391cbd46783f0230d4"
    sha256 cellar: :any,                 big_sur:        "44482bd90787c77de93a589265ca0eb139c21dfb9c375307041146f88a6750f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b317aaefababd9955137556a3a246368fd4724370532013be9759bd39ed1501"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :test
  depends_on "qt@5"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/46/0d/b06cf99a64d4187632f4ac9ddf6be99cd35de06fe72d75140496a8e0eef5/pyzmq-24.0.1.tar.gz"
    sha256 "216f5d7dbb67166759e59b0479bca82b8acf9bed6015b526b8eb10143fb08e77"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "install"
  end

  test do
    python3 = "python3.11"

    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    venv = virtualenv_create(testpath/"vendor", python3)
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
