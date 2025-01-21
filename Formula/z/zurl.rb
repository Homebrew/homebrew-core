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
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:  "caac867d6cd84464d1432597b7f87521ad5d971e12aded4455068d0e227c7d6b"
    sha256 cellar: :any,                 arm64_ventura: "db24a1c2b45dacb21bc6d983c7cc243e3a4c66e405e92ea1e1b755c920adf647"
    sha256 cellar: :any,                 sonoma:        "3c269fb6fafc531fb6738e3e5b8f21085526b3278068bddd1f606342f5d14bb2"
    sha256 cellar: :any,                 ventura:       "e97837c8f2141e8ff0dfe985fca0b6924a894b9a0fcc023a4808491eb67b3503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e03115779822a91ea2c4547dae103f6538beeab596a56251aad671519c1becd8"
  end

  depends_on "pkgconf" => :build
  depends_on "cmake" => :test # for scikit_build_core
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.13" => :test
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
      url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
      sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
    end

    resource "pathspec" do
      url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
      sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
    end

    resource "pyzmq" do
      url "https://files.pythonhosted.org/packages/fd/05/bed626b9f7bb2322cdbbf7b4bd8f54b1b617b0d2ab2d3547d6e39428a48e/pyzmq-26.2.0.tar.gz"
      sha256 "070672c258581c8e4f640b5159297580a9974b026043bd4ab0470be9ed324f1f"
    end

    resource "scikit-build-core" do
      url "https://files.pythonhosted.org/packages/34/75/ad5664c8050bbbea46a5f2b6a3dfbc6e6cf284826c0eee0a12f861364b3f/scikit_build_core-0.10.7.tar.gz"
      sha256 "04cbb59fe795202a7eeede1849112ee9dcbf3469feebd9b8b36aa541336ac4f8"
    end

    resource "setuptools" do
      url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
      sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
    end

    python3 = "python3.13"

    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python3)
    venv = virtualenv_create(testpath/"vendor", python3)
    venv.pip_install resources.reject { |r| r.name == "pyzmq" }
    venv.pip_install(resource("pyzmq"), build_isolation: false)

    conffile.write <<~INI
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
    INI

    port = free_port
    runfile.write <<~PYTHON
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
    PYTHON

    pid = spawn bin/"zurl", "--config=#{conffile}"
    begin
      system testpath/"vendor/bin"/python3, runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
