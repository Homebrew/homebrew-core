class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/52/9a/ab43cf8fb4847a6fda585beb1374deba0583660fa05c882a498784b2fc77/uwsgi-2.0.25.1.tar.gz"
  sha256 "d653d2d804c194c8cbe2585fa56efa2650313ae75c686a9d7931374d4dfbfc6e"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "983fe6f7af185a9153320b3cd52204dd748e0f41b695f8c6f098e0e11e1a871d"
    sha256 arm64_ventura:  "b368a4c314a02ff7a8eb6711ee039b257114fdbed533b32e7585c0d41f8ef9e4"
    sha256 arm64_monterey: "6c09b2e859d6383de85d3e3b8949c24a80d9f5071dfef98fb0f698409be1b7b5"
    sha256 sonoma:         "5b3a6199dd5cf18504365fa22ca45cde1c861d52a3512ce6a5c2764c985400a1"
    sha256 ventura:        "042a3a53a27cf8fb4132cb8de7d1b03ab02e243f38b46aeddc009538841b1cf5"
    sha256 monterey:       "aa8065251cf0676dc1f7a0890c8f78295631fa916ffad0aa9319f8d6e3fa6750"
    sha256 x86_64_linux:   "d24bc23d5bfcd050697811e1b57950f138fec1b05600e0986c205b80832f5ab2"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/unbit/uwsgi/issues/2486
  depends_on "python@3.12"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    openssl = Formula["openssl@3"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    (buildpath/"buildconf/brew.ini").write <<~EOS
      [uwsgi]
      ssl = true
      json = yajl
      xml = libxml2
      yaml = embedded
      inherit = base
      plugin_dir = #{libexec}/uwsgi
      embedded_plugins = null
    EOS

    python3 = "python3.12"
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
    (testpath/"helloworld.py").write <<~EOS
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return [b"Hello World"]
    EOS

    port = free_port

    pid = fork do
      exec "#{bin}/uwsgi --http-socket 127.0.0.1:#{port} --protocol=http --plugin python3 -w helloworld"
    end
    sleep 2

    begin
      assert_match "Hello World", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
