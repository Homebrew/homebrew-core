class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  revision 4
  head "https://github.com/unbit/uwsgi.git"

  stable do
    url "https://projects.unbit.it/downloads/uwsgi-2.0.18.tar.gz"
    sha256 "4972ac538800fb2d421027f49b4a1869b66048839507ccf0aa2fda792d99f583"

    # Fix "library not found for -lgcc_s.10.5" with 10.14 SDK
    # Remove in next release
    patch do
      url "https://github.com/unbit/uwsgi/commit/6b1b397f.diff?full_index=1"
      sha256 "b2c3a22f980a4e3bd2ab2fe5c5356d8a91e567a3ab3e6ccbeeeb2ba4efe4568a"
    end
  end

  bottle do
    sha256 "6c82bba2d7564bd3409867d304c578c7823d7c1db019d8b4c8223ae569a5f247" => :catalina
    sha256 "2a3b1c26400d68491409b8625f56c730a2f69bbb5acc2596c80ea4cba3435fad" => :mojave
    sha256 "2c511739e0317173b7c82b15a87a0eade429ed88be667801b477c95dc2affd72" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.8"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

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

    system "python3", "uwsgiconfig.py", "--verbose", "--build", "brew"

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

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python3", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    system "python3", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", "python3"

    bin.install "uwsgi"
  end

  plist_options manual: "uwsgi"

  def plist
    <<~EOS
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
