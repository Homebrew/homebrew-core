class Zurl < Formula
  include Language::Python::Virtualenv

  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://github.com/fanout/zurl/releases/download/v1.11.1/zurl-1.11.1.tar.bz2"
  sha256 "39948523ffbd0167bc8ba7d433b38577156e970fe9f3baa98f2aed269241d70c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "a6cae5932ecc6e54b3874c5c0ffd3fd42938a5cc73858647941f50e669326eea"
    sha256 cellar: :any,                 arm64_monterey: "3e64b28ec36eb751cf1eedc05403644f751e6833ee0ab4ffb4543adb005fb42a"
    sha256 cellar: :any,                 arm64_big_sur:  "9a86510d8ffb9c0550c7dcfc14fe92cd20b876c4ded19db26f1ca14b81657bc7"
    sha256 cellar: :any,                 ventura:        "34e3faccba5108af712ee514615b60bfcdaf10968e04860559c8c80a25a85b2f"
    sha256 cellar: :any,                 monterey:       "43b4a966a87dc863c364b4c48ebf6de61fd82599bfa85b64a5e715d367d30de5"
    sha256 cellar: :any,                 big_sur:        "80bb1d4733e032fdc64bb18f08edac44eca3095f290f8f74216662cab66313c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c6ed0468ae2c6b2fbfb73cd4bc2f83e3f625494040a0e34177faca58ec4849"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :test
  depends_on "qt@5"
  depends_on "zeromq"

  uses_from_macos "curl"

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
