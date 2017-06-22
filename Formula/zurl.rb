class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://dl.bintray.com/fanout/source/zurl-1.7.1.tar.bz2"
  sha256 "d94970bafb64224e233e060d1ae591b3f418e1d809afe46099c3c16f19322187"
  revision 1

  bottle do
    cellar :any
    sha256 "49eb5fac9eefde9b2472cb840c2d53fe830ea86cb0988c720494c296027bd10f" => :sierra
    sha256 "b2dc989f0a256550348e909f122b8324b3f23f9b42ecb80c8023d1e6a4565d07" => :el_capitan
    sha256 "de5149502ebdc56ac4d34b808b181b32aa26a6195d3cd2c03daa820e9ace7b8c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version < :lion
  depends_on "qt"
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
