class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/24/fd/93851e4a076719199868d4c918cc93a52742e68370188c1c570a6e42a54f/uwsgi-2.0.20.tar.gz"
  sha256 "88ab9867d8973d8ae84719cf233b7dafc54326fcaec89683c3f9f77c002cdff9"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "97b816a997de0bac3f0700c63d4580449d448ac75cb42845de265e76eef53597"
    sha256 arm64_big_sur:  "8dd8c0cae8366843f45d90f54e744d92972140980560d51bf460b7dacf5dee5c"
    sha256 monterey:       "7088b0e2aa2d25169c4103320c0b84f60ef4a64f81c770c058f6e508593675cd"
    sha256 big_sur:        "c03ad9573cd5ec714c4be065202918e346e64edf8188019640eabe22f57d7b77"
    sha256 catalina:       "cbaf0bc7eeb58695feac872232efacc4770a0e766ff985d1a4cce3115bc41971"
    sha256 x86_64_linux:   "09c64389194544939d8f47976722737d3241736738b0c3b92643bb97c0f4d9b1"
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
