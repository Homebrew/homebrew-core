class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b3/8e/b4fb9f793745afd6afcc0d2443d5626132e5d3540de98f28a8b8f5c753f9/uwsgi-2.0.21.tar.gz"
  sha256 "35a30d83791329429bc04fe44183ce4ab512fcf6968070a7bfba42fc5a0552a9"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9f14390de18ef1adb63a98c4f5a19b146fa02cb6f99485ae513ca9fefe0e09bb"
    sha256 arm64_monterey: "9d1929c7a720d4ad1f8f8f4f8cef51bed5833e5adc5881da44e6f5b7946abbc6"
    sha256 arm64_big_sur:  "a3dfad629f7fc0aeb1df752862fe3311ae7aa1684dacf3225264187344b7ea7e"
    sha256 ventura:        "8088e630d033c27705b52a86ee4f7622094490eaf5e0f544456e0b9c45a37584"
    sha256 monterey:       "2dc03c4a6aa1503256a73a59bc54a4abe9a478c647a0f35c63d8300f5f951115"
    sha256 big_sur:        "d25cafb4c641df72f8b3b23ece9257e7c44c2c3dbaee2fcb222e14e2e1926292"
    sha256 catalina:       "2e1ff38549441c6d30dfd1a9a43c9dff3bca37f84463c9661280324be112160a"
    sha256 x86_64_linux:   "2c7d7ec6a3dbffb363190886a92977fadd48cfd14553c950ace7825037c09567"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.10"
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
    openssl = Formula["openssl@1.1"]
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

    python3 = "python3.10"
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
