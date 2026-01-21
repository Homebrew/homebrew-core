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
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb2c86141ca65e087181c6d802dad72bb3d0b3ecd75286663077b29ef5ee8ed6"
    sha256 cellar: :any,                 arm64_sequoia: "6b0d185ef6601a9a7feb2712ac0b7d4242e8e35e4572cb8aca3c88109461f1fd"
    sha256 cellar: :any,                 arm64_sonoma:  "b75dbe6b4c8eb60c671c68c1adeb4bf0fd4ec011051c34bae3342ee49bb3a1a3"
    sha256 cellar: :any,                 sonoma:        "318fd22b894af157b9a54a874d13c805b1474d97a43cd50e0e39f15262472b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591a82d1ae225eeab0cd35808e860c1b69b9cf84d13ef87962aa4f0b24c0ddfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9298662889e90ecfc5078599cfeab0862621e9839b92af94a93b32b5db4430"
  end

  depends_on "pkgconf" => :build
  depends_on "cmake" => :test # for scikit_build_core
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.14" => :test
  depends_on "qtbase"
  depends_on "zeromq"

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["--qtselect=#{Formula["qtbase"].version.major}"]
    args << "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "install"
  end

  test do
    resource "packaging" do
      url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
      sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
    end

    resource "pathspec" do
      url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
      sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
    end

    resource "pyzmq" do
      url "https://files.pythonhosted.org/packages/04/0b/3c9baedbdf613ecaa7aa07027780b8867f57b6293b6ee50de316c9f3222b/pyzmq-27.1.0.tar.gz"
      sha256 "ac0765e3d44455adb6ddbf4417dcce460fc40a05978c08efdf2948072f6db540"
    end

    resource "scikit-build-core" do
      url "https://files.pythonhosted.org/packages/34/75/ad5664c8050bbbea46a5f2b6a3dfbc6e6cf284826c0eee0a12f861364b3f/scikit_build_core-0.10.7.tar.gz"
      sha256 "04cbb59fe795202a7eeede1849112ee9dcbf3469feebd9b8b36aa541336ac4f8"
    end

    resource "setuptools" do
      url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
      sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
    end

    python3 = "python3.14"

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
