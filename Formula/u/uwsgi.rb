class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/24/c2/d58480aadc9a1f420dd96fc43cf0dcd8cb5ededb95cab53743529c23b6cd/uwsgi-2.0.28.tar.gz"
  sha256 "79ca1891ef2df14508ab0471ee8c0eb94bd2d51d03f32f90c4bbe557ab1e99d0"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f57a1a48e3c6a9e34a580a47448ef9b4f7859b307871efcacc7fb30ac80269ff"
    sha256 arm64_sonoma:  "9a19faaa101548dc4a49f8c9cc187cd7ada753a8752867073af55f1bc1fcbd59"
    sha256 arm64_ventura: "3ddd8691d4daf943cc326623d205ae7b4b7a751d1199e4119474becc166e6b0d"
    sha256 sonoma:        "91ac6f68d094cfb448ff535b849ce94461e7f84331d5c53d6de313a93c330648"
    sha256 ventura:       "8ff239f69cbc9fbb85c9ba4296f4805b96d9b146237b481c11ee82cfb411e2fe"
    sha256 x86_64_linux:  "837e3580174d833939e92f51d97664d092d0cd4e4f1ad167429f743aaeed865b"
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

    pid = fork do
      exec "#{bin}/uwsgi --http-socket 127.0.0.1:#{port} --protocol=http --plugin python3 -w helloworld"
    end
    sleep 4

    begin
      assert_match "Hello World", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
