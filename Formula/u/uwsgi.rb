class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/49/2f57640e889ba509fd1fae10cccec1b58972a07c2724486efba94c5ea448/uwsgi-2.0.31.tar.gz"
  sha256 "e8f8b350ccc106ff93a65247b9136f529c14bf96b936ac5b264c6ff9d0c76257"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "3c36ef0487dd1f7fa40d9741ce01dc2657582ba76e1879b8b0de066515d1b3d8"
    sha256 arm64_sequoia: "6f7f4e12229641099470b25ce4632430453d587dea74ca6d1ddcd536a1f56b60"
    sha256 arm64_sonoma:  "dbbbdcde2bd3c5a0b8654a90d449340f160a249a7102b2b9b6269e83ba129f2f"
    sha256 sonoma:        "80fd46872c6dab38b10b83ea73bae5c24e68e52a5fe8983b00de3a7312c87768"
    sha256 arm64_linux:   "97a745c0f389067dfd9501355f05b5dd55245cba77658ca888fec497c882bcb7"
    sha256 x86_64_linux:  "8af74b0f5b72985bbe1aeb2014638df4111fca18e89f11149cc5fd0ce3c4d51e"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14"
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
    "python3.14"
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
