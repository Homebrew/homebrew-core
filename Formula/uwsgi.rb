class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.org/en/latest/"
  url "https://projects.unbit.it/downloads/uwsgi-2.0.15.tar.gz"
  sha256 "572ef9696b97595b4f44f6198fe8c06e6f4e6351d930d22e5330b071391272ff"
  head "https://github.com/unbit/uwsgi.git"

  bottle do
    sha256 "09cd8cf501bb7ffd6dc1ce48628c80798700d3b79e329321e59c98a6e3d127e1" => :sierra
    sha256 "94d275b2699c23828ff7610372a3b6b5ff11ec63222eba33db6de22adb806424" => :el_capitan
    sha256 "986cb7457249c53bf40df451f39675a8871fdefe1f111ae7e02eb70a89404ab5" => :yosemite
  end

  option "with-php", "Compile with PHP support (PHP must be built for embedding)"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "openssl"
  depends_on "yajl"
  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "libxslt" => :optional
  depends_on "python" => :optional
  depends_on "python3" => :optional
  depends_on "v8" => :optional

  # "no such file or directory: '... libpython2.7.a'"
  # Reported 23 Jun 2016: https://github.com/unbit/uwsgi/issues/1299
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/726bff4/uwsgi/libpython-tbd-xcode-sdk.diff"
    sha256 "d71c879774b32424b5a9051ff47d3ae6e005412e9214675d806857ec906f9336"
  end

  def install
    ENV.append %w[CFLAGS LDFLAGS], "-arch #{MacOS.preferred_arch}"
    openssl = Formula["openssl"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    (buildpath/"buildconf/brew.ini").write <<-EOS.undent
      [uwsgi]
      ssl = true
      json = yajl
      yaml = embedded
      inherit = base
      plugin_dir = #{libexec}/uwsgi
      embedded_plugins = null
    EOS

    system "python", "uwsgiconfig.py", "--verbose", "--build", "brew"

    plugins = %w[airbrake alarm_curl alarm_speech asyncio cache
                 carbon cgi cheaper_backlog2 cheaper_busyness
                 corerouter curl_cron cplusplus dumbloop dummy
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

    plugins << "php" if build.with? "php"
    plugins << "v8" if build.with? "v8"
    plugins << "xslt" if build.with? "libxslt"

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    python_versions = {
      "python"=>"python",
      "python2"=>"python",
    }
    python_versions["python3"] = "python3" if build.with? "python3"
    python_versions.each do |k, v|
      system v, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", k
    end

    bin.install "uwsgi"
  end

  plist_options :manual => "uwsgi"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/uwsgi</string>
            <string>--uid</string>
            <string>_www</string>
            <string>--gid</string>
            <string>_www</string>
            <string>--master</string>
            <string>--die-on-term</string>
            <string>--autoload</string>
            <string>--logto</string>
            <string>#{HOMEBREW_PREFIX}/var/log/uwsgi.log</string>
            <string>--emperor</string>
            <string>#{HOMEBREW_PREFIX}/etc/uwsgi/apps-enabled</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"helloworld.py").write <<-EOS.undent
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return [b"Hello World"]
    EOS

    pid = fork do
      exec "#{bin}/uwsgi --http-socket 127.0.0.1:8080 --protocol=http --plugin python -w helloworld"
    end
    sleep 2

    begin
      assert_match "Hello World", shell_output("curl localhost:8080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
