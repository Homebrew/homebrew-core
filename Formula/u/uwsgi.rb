class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/49/2f57640e889ba509fd1fae10cccec1b58972a07c2724486efba94c5ea448/uwsgi-2.0.31.tar.gz"
  sha256 "e8f8b350ccc106ff93a65247b9136f529c14bf96b936ac5b264c6ff9d0c76257"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8dd8f54a7be80ec021184630117cbe46686d1cae882d9810a4a9ebef828e74d8"
    sha256 arm64_sequoia: "27e31b191d640607160d070ef0ebfa5f0bf5589c53c6c940726a4f48ab4b48ed"
    sha256 arm64_sonoma:  "ab6bf0340b7c8ddfbd391781f45dd2d19ceca19ba2911f9321479ff15aaa37b6"
    sha256 sonoma:        "3b99b7a279046bcb989caaf7eb2c5e97554dce20ac05c758bb079dcef4833cc3"
    sha256 arm64_linux:   "714fd6fe7f6666bb298fdb4032e4ed683fb2e9a543316099265cd2dac8c91304"
    sha256 x86_64_linux:  "3df9e1bafa096221e61f8c5fd50b39e71bdaf9d481164142423553bba0bdbcf3"
  end

  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
  end

  def python3
    "python3.14"
  end

  def install
    openssl = Formula["openssl@3"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    (buildpath/"buildconf/brew.ini").write <<~INI
      [uwsgi]
      ssl = true
      json = jansson
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
