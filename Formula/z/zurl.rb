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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "29419455dd218e5cca794fef679128a0e193c14b859d8d517cef731a03d518f6"
    sha256 cellar: :any,                 arm64_ventura:  "70ab20c9abacad98555e412aa8b942d478965428f41f1f28a4a90b41012e3753"
    sha256 cellar: :any,                 arm64_monterey: "5a7f5071e096c8dead6a23493df5fe36a6e7e1b7dd6417c6b41029dd48f5517c"
    sha256 cellar: :any,                 sonoma:         "d6974d31c07fce5247d6681c9737d60c00a8288155d1f15494f6581437f346ca"
    sha256 cellar: :any,                 ventura:        "a0df5794c3daba640e7081980d9bfac9c0c14cd3304320ab94a6441a6c6d4fb3"
    sha256 cellar: :any,                 monterey:       "99a6f58fcd6e527e33917dffa2f9eabf009db7a1fc0685c31d8d59181a79dbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1fcebfc7d0dc691d59d329e077d4246d425ea597ada56e0cb603e40232dc34"
  end

  depends_on "pkg-config" => :build
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.12" => :test
  depends_on "qt"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["--qtselect=#{Formula["qt"].version.major}"]
    args << "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "install"
  end

  test do
    resource "packaging" do
      url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
      sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
    end

    resource "pyzmq" do
      url "https://files.pythonhosted.org/packages/3a/33/1a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341/pyzmq-25.1.2.tar.gz"
      sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
    end

    resource "setuptools" do
      url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
      sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
    end

    python3 = "python3.12"

    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python3)
    venv = virtualenv_create(testpath/"vendor", python3)
    venv.pip_install resources.reject { |r| r.name == "pyzmq" }
    venv.pip_install(resource("pyzmq"), build_isolation: false)

    conffile.write <<~EOS
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
    EOS

    port = free_port
    runfile.write <<~EOS
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

    pid = fork do
      exec bin/"zurl", "--config=#{conffile}"
    end

    begin
      system testpath/"vendor/bin/#{python3}", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
