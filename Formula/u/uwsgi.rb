class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/49/2f57640e889ba509fd1fae10cccec1b58972a07c2724486efba94c5ea448/uwsgi-2.0.31.tar.gz"
  sha256 "e8f8b350ccc106ff93a65247b9136f529c14bf96b936ac5b264c6ff9d0c76257"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "127cb65efdc4c3f17cadd41df9671470e3e46fb53cadd74f187a2731d70a5a24"
    sha256 arm64_sequoia: "7c31e1a3dfd42985bee1cd99e9007f04eca92688d937ad93b393cdc3f1eb42f8"
    sha256 arm64_sonoma:  "3d420cb75e801cca0931cba8eff85c88fbe079ccb80a180e53f72d299d04bfe2"
    sha256 sonoma:        "e4b665aac3350632869764e7893dc37b097cffc8ecc859c591c6638b0ab34382"
    sha256 arm64_linux:   "7ec886511a95fdc64f92b33c9374a134a690b03f11681ac6f6761649eefa3127"
    sha256 x86_64_linux:  "5668da0a96c26781423fe1d489f1a52c3afbaa76aebf156d092e3b5f37e11c78"
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
