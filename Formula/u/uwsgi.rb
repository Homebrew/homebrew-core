class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e1/46/fb08706bc5d922584a5aaed1f73e7a17313310aa34615c74406112ea04a6/uwsgi-2.0.27.tar.gz"
  sha256 "3ee5bfb7e6e9c93478c22aa8183eef35b95a2d5b14cca16172e67f135565c458"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "93d5e4dc64a853efc3c181b1e3a98580853633f79a8844b36aa0d0907bc403f2"
    sha256 arm64_sonoma:  "d3d437e9650fe255a94848ddfae25f3505159408f35abfd91376009c4db1355b"
    sha256 arm64_ventura: "1e24fb7c34bd01d8bb75efbfa23380bccaab38681d881243f4ecad2dd04bb490"
    sha256 sonoma:        "6ad052496e956233a114de63957b3b944c925145f611ad9acd3ac2de19239b16"
    sha256 ventura:       "4b021c120ac0054da777731ebf2dd8630360f8872c54a3571df398cfa1cd288b"
    sha256 x86_64_linux:  "1e6a8387477cd3dec6710c526a43243ab80e66122393b31c271dab56ae202b68"
  end

  depends_on "pkg-config" => :build
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
