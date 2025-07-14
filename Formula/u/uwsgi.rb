class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6f/f0/d794e9c7359f488b158e88c9e718c5600efdb74a0daf77331e5ffb6c87c4/uwsgi-2.0.30.tar.gz"
  sha256 "c12aa652124f062ac216077da59f6d247bd7ef938234445881552e58afb1eb5f"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b2386757296c38cd05ba889d19d2bc6d29c07ba6124657f1d905965fc3da1e1a"
    sha256 arm64_sonoma:  "45c740b6194c9740b2d88e40a67ebf5d6019869e13faf2b40d6cf747a87808d3"
    sha256 arm64_ventura: "dd78e316d8d60fc40c16425d7bd57788725052921e79bd1291a81c81f1c3b00d"
    sha256 sonoma:        "8c1aff88354475b992347f8449ef581753a402dce09b4318d6c6ef1c378d4e65"
    sha256 ventura:       "0de8c5fcee50137e7e2346567afb07ec1fa9b995bd3392604f1e3e812393824e"
    sha256 arm64_linux:   "472b257c4aa0a1ff3d7e915bda3196681cc459de6964b19d9670cf26ee3516e1"
    sha256 x86_64_linux:  "3c27e5bd84f5135985cce5e2c13f8a7845074bab10040fccf09caa9d0bc0e4d9"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
  end

  def python3
    "python3.13"
  end

  def install
    openssl = Formula["openssl@3"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    (buildpath/"buildconf/brew.ini").write <<~INI
      [uwsgi]
      ssl = true
      json = yajl
      xml = libxml2
      yaml = embedded
      inherit = base
      plugin_dir = #{libexec}/uwsgi
      embedded_plugins = null
    INI

    system python3, "uwsgiconfig.py", "--verbose", "--build", "brew"

    plugins = %w[airbrake alarm_curl asyncio cache
                 carbon cgi cheaper_backlog2 cheaper_busyness
                 corerouter curl_cron dumbloop dummy
                 echo emperor_amqp fastrouter forkptyrouter gevent
                 http logcrypto logfile ldap logpipe logsocket
                 msgpack notfound pam ping psgi pty rawrouter
                 router_basicauth router_cache router_expires
                 router_hash router_http router_memcached
                 router_metrics router_radius router_redirect
                 router_redis router_rewrite router_static
                 router_uwsgi router_xmldir rpc signal spooler
                 sqlite3 sslrouter stats_pusher_file
                 stats_pusher_socket symcall syslog
                 transformation_chunked transformation_gzip
                 transformation_offload transformation_tofile
                 transformation_toupper ugreen webdav zergpool]
    plugins << "alarm_speech" if OS.mac?
    plugins << "cplusplus" if OS.linux?

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system python3, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    system python3, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", "python3"

    bin.install "uwsgi"
  end

  service do
    run [opt_bin/"uwsgi", "--uid", "_www", "--gid", "_www", "--master", "--die-on-term", "--autoload", "--logto",
         HOMEBREW_PREFIX/"var/log/uwsgi.log", "--emperor", HOMEBREW_PREFIX/"etc/uwsgi/apps-enabled"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"helloworld.py").write <<~PYTHON
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return [b"Hello World"]
    PYTHON

    port = free_port
    args = %W[
      --http-socket 127.0.0.1:#{port}
      --protocol=http
      --plugin python3
      -w helloworld
    ]
    pid = spawn("#{bin}/uwsgi", *args)
    sleep 4
    sleep 6 if Hardware::CPU.intel?

    begin
      assert_match "Hello World", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
