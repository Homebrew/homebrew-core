class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b3/8e/b4fb9f793745afd6afcc0d2443d5626132e5d3540de98f28a8b8f5c753f9/uwsgi-2.0.21.tar.gz"
  sha256 "35a30d83791329429bc04fe44183ce4ab512fcf6968070a7bfba42fc5a0552a9"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b28c9d037f4c185b1104deb950274bf10e2b2cd20da14e8e1a1ab98008a730f9"
    sha256 arm64_monterey: "b0d8ceaef5da714dab88bb9b15669abe348a081e8d4cdf90d7f446c70f91e2fe"
    sha256 arm64_big_sur:  "e5d9c4b40defd7690579f7e4229fdeed689e7f1d89fd20aa224eaee3bfd906ad"
    sha256 ventura:        "c5689a1fac003060742263dff7f40985f7f62b0c724f6f42c0a61ab4c2e56642"
    sha256 monterey:       "880a052cb9f304815db7ff085c957b07257036d3609908f466325833aac864cb"
    sha256 big_sur:        "43d8fd1d5c42c128a9ac189ef7659f57df1da2703dea0c46ce486e55b35645b2"
    sha256 x86_64_linux:   "1eea101f6821a7fa4a8c06164a7a6cff283f4b698ba9625b4cf7dfc2749a85df"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/unbit/uwsgi/issues/2486
  depends_on "python@3.11"
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

    python3 = "python3.11"
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
