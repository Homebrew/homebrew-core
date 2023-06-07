class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b3/8e/b4fb9f793745afd6afcc0d2443d5626132e5d3540de98f28a8b8f5c753f9/uwsgi-2.0.21.tar.gz"
  sha256 "35a30d83791329429bc04fe44183ce4ab512fcf6968070a7bfba42fc5a0552a9"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7f14aa760665a509bf46d1abb5639cac6174ed616047c7f372bdadae6312f465"
    sha256 arm64_monterey: "5453ff8bcb1637f404c16fa05aeb016a7343254ea1327253336207394ca65918"
    sha256 arm64_big_sur:  "025fca9344cb4240ff9bf8e2bf50970af379abe9f05bb483f8a4f69c204e6b87"
    sha256 ventura:        "27a8c1cc7e4ab54604ff3d02e6e29cb47874d04c2895e2b3085d621253d2614e"
    sha256 monterey:       "e3c7683d1359132dd1186de5617abc382f44a40fba22baf78c3b2b76800b7cb1"
    sha256 big_sur:        "b55da7aab455f3e3521686e99f2ba5261d798c0364fd346498879944a0ab40e0"
    sha256 x86_64_linux:   "3d32743d10ebefde4fdb6f4c7d2ae171de4d322da53fc9f8732d593cd43d6092"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
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
