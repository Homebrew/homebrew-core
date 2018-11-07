class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.org/en/latest/"
  head "https://github.com/unbit/uwsgi.git"

  stable do
    url "https://projects.unbit.it/downloads/uwsgi-2.0.17.1.tar.gz"
    sha256 "d2318235c74665a60021a4fc7770e9c2756f9fc07de7b8c22805efe85b5ab277"

    # Fix "library not found for -lgcc_s.10.5" with 10.14 SDK
    # Remove in next release
    patch do
      url "https://github.com/unbit/uwsgi/commit/6b1b397f.diff?full_index=1"
      sha256 "b2c3a22f980a4e3bd2ab2fe5c5356d8a91e567a3ab3e6ccbeeeb2ba4efe4568a"
    end
  end

  bottle do
    rebuild 1
    sha256 "bedd428644e52332dea9c0c022e1b95572e86b82a26f00676d9041e1d3668041" => :mojave
    sha256 "a324da423d63b2e6fa8c36680a84a19c5a2a82f33c8e819c1c3c3ca318fb48a7" => :high_sierra
    sha256 "c46dd9c0e215063d503b275759ec1055521b124d1f8c5d378de086d186089088" => :sierra
  end

  deprecated_option "with-python3" => "with-python"

  depends_on "go" => [:build, :optional]
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre"
  depends_on "python@2"
  depends_on "yajl"

  depends_on "libyaml" => :optional
  depends_on "python" => :optional
  depends_on "zeromq" => :optional

  # "no such file or directory: '... libpython2.7.a'"
  # Reported 23 Jun 2016: https://github.com/unbit/uwsgi/issues/1299
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/726bff4/uwsgi/libpython-tbd-xcode-sdk.diff"
    sha256 "d71c879774b32424b5a9051ff47d3ae6e005412e9214675d806857ec906f9336"
  end

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    ENV.append %w[CFLAGS LDFLAGS], "-arch #{MacOS.preferred_arch}"
    openssl = Formula["openssl"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    yaml = build.with?("libyaml") ? "libyaml" : "embedded"

    (buildpath/"buildconf/brew.ini").write <<~EOS
      [uwsgi]
      ssl = true
      json = yajl
      xml = libxml2
      yaml = #{yaml}
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

    plugins << "gccgo" if build.with? "go"

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    python_versions = {
      "python"  => "python2.7",
      "python2" => "python2.7",
    }
    python_versions["python3"] = "python3" if build.with? "python"
    python_versions.each do |k, v|
      system v, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", k
    end

    bin.install "uwsgi"
  end

  plist_options :manual => "uwsgi"

  def plist; <<~EOS
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
    (testpath/"helloworld.py").write <<~EOS
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
