class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/unbit/uwsgi.git", branch: "master"

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
    rebuild 2
    sha256 arm64_monterey: "8dddd4ed44cb3daa458eeae7060551bbfd479f8d3863f896f80eb821d24ef877"
    sha256 arm64_big_sur:  "4326330a1880f7901c4168d85134a37f44de0e786e5fe76a9e9ecd16ed833a58"
    sha256 monterey:       "fe3556331a8a1b1b20b701de68a214903034fc924c7572ffde6cb47c2c292a57"
    sha256 big_sur:        "dd093fa094a07dba5ac53f040eaed23a9b61adc80b6cc50de246d160fcff0a34"
    sha256 catalina:       "8194d4a365e0ce4d3ee5fd9764d008c6d0aabf6c804414d5a6b0733295f9d101"
    sha256 mojave:         "2def48a9cc74853449722f5dc51a0224956d21906d8ff35e73a45fab3fc3faef"
    sha256 x86_64_linux:   "acb0c806523fc521f4c703b5fe952b488f473a5eac99d5c877ac2fec2a117782"
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

  on_linux do
    depends_on "linux-pam"
  end

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

    plugins = %w[airbrake alarm_curl asyncio cache
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
    plugins << "alarm_speech" if OS.mac?

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python3", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    system "python3", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", "python3"

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
