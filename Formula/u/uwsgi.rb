class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/af/74/34f5411f1c1dc55cbcba3d817d1723b920484d2aeede4663bbaa5be7ee22/uwsgi-2.0.29.tar.gz"
  sha256 "6bd150ae60d0d9947429ea7dc8e5f868de027e5eb38355fb613b9413732c432f"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "d0de47a93650ac9a647ca1993d544e58594f13ecf44c74be30d82e6c21c6a3ee"
    sha256 arm64_sonoma:  "63e804aa021c578d63efee146a7de4c14da0c32112a5f9191f9206cdd97c8eea"
    sha256 arm64_ventura: "d84676d2359811575925b6bdbdd1a27783426d8b5b852deb98377c8e9b51f7a2"
    sha256 sonoma:        "dc6829ecbb85e22d148e917a616932e6dad93a5be054acacad11e5ecdd806fe9"
    sha256 ventura:       "87f2ef9402ac05723ff24c4ea1b9594ad959f19f9895b11d8411e197d3df616d"
    sha256 arm64_linux:   "a5431eded1a13c7f3c02242c7aefa988053db24c02767b81847436f6c5da1137"
    sha256 x86_64_linux:  "38727ddcb072891b2929e8cc22c87afb78e044e9dc783b532b8353e452f53899"
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
