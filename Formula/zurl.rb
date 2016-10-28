class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://dl.bintray.com/fanout/source/zurl-1.7.0.tar.bz2"
  sha256 "e2af9ea04ca32a2ed9446c9a0c7d0a261346e98f58c126776d2580d7a20a61f1"

  bottle do
    cellar :any
    sha256 "1bf6a4e242c010deb166a7eb79f4a6cd51711f36df1a531f356b86e6a98801d3" => :sierra
    sha256 "b35d05ae25650d67461d7c9cb95a95f170a10e22a62c4179f1b331bb88b40005" => :el_capitan
    sha256 "85d1e54cadcef1f206d7a1749c24d59f41941db64a693ac3a729b1478f3e7041" => :yosemite
    sha256 "c04e8b13ff3984009f88400a8eb6e44fc738ea537eec6fb9c92e77a39d16969d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version < :lion
  depends_on "qt5"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/12/b8/06a9c0769d1f8024f8ffc516e4150a959d05658fc27eaead5cc199d31194/pyzmq-16.0.0.tar.gz"
    sha256 "712000cc23e3845936d22b6085be40679fd38d789a3d20836be191b8a86f15a7"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    resource("pyzmq").stage { system "python", *Language::Python.setup_install_args(testpath/"vendor") }

    conffile.write(<<-EOS.undent
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
      EOS
                  )

    runfile.write(<<-EOS.undent
      import json
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      import zmq
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
      port = None
      def server_worker(c):
        global port
        server = HTTPServer(('', 0), TestHandler)
        port = server.server_address[1]
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
      req = {'id': '1', 'method': 'GET', 'uri': 'http://localhost:%d/test' % port}
      sock.send('J' + json.dumps(req))
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
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
