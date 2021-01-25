class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  license "GPL-2.0-or-later"
  head "https://github.com/unbit/uwsgi.git"

  stable do
    url "https://files.pythonhosted.org/packages/c7/75/45234f7b441c59b1eefd31ba3d1041a7e3c89602af24488e2a22e11e7259/uWSGI-2.0.19.1.tar.gz"
    sha256 "faa85e053c0b1be4d5585b0858d3a511d2cd10201802e8676060fd0a109e5869"

    # Fix "library not found for -lgcc_s.10.5" with 10.14 SDK
    # Remove in next release
    patch do
      url "https://github.com/unbit/uwsgi/commit/6b1b397f.patch?full_index=1"
      sha256 "85725f31ea0f914e89e3abceffafc64038ee5e44e979ae85eb8d58c80de53897"
    end
  end

  bottle do
    sha256 "3ff3a21eaf20a4132dc2b2da9405129a9aae59584c422b57cfa6f6cdfa29937c" => :big_sur
    sha256 "4128d2e3c32af1db0ca94dc74f30d07076b5190668630a68f68cb898441c0b9a" => :arm64_big_sur
    sha256 "339d8ce59b4cd8657a62b322b26e89649847d32c4c8a1ff149e2e16dd4cc4ff2" => :catalina
    sha256 "f885fbd73900a196ff2438bc5c14771b0bc8c9cad0a7f59c1cbb39f484205ed5" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.9"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

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
