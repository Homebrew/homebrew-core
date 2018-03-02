class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.org/en/latest/"
  url "https://projects.unbit.it/downloads/uwsgi-2.0.17.tar.gz"
  sha256 "3dc2e9b48db92b67bfec1badec0d3fdcc0771316486c5efa3217569da3528bf2"
  head "https://github.com/unbit/uwsgi.git"

  bottle do
    sha256 "c42839806ac4d5e1bcf9348909cb2012284ef20f69e646981ad11fb5bf9448d1" => :high_sierra
    sha256 "87b5877671e1b1dd1c7aebe3dca1c2068e40d68c4f922de0610fae4b88a52f97" => :sierra
    sha256 "33a07fe69d0831fa4eb6e601ec2e406ef059bbe7984badd3ad855eab6efb039b" => :el_capitan
  end

  option "with-java", "Compile with Java support"
  option "with-ruby", "Compile with Ruby support"

  deprecated_option "with-lua51" => "with-lua@5.1"
  deprecated_option "with-python3" => "with-python"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "openssl"
  depends_on "python@2" if MacOS.version <= :snow_leopard

  depends_on "geoip" => :optional
  depends_on "gloox" => :optional
  depends_on "go" => [:build, :optional]
  depends_on "jansson" => :optional
  depends_on "libffi" => :optional
  depends_on "libxslt" => :optional
  depends_on "libyaml" => :optional
  depends_on "lua@5.1" => :optional
  depends_on "mongodb" => :optional
  depends_on "mongrel2" => :optional
  depends_on "mono" => :optional
  depends_on "nagios" => :optional
  depends_on "postgresql" => :optional
  depends_on "pypy" => :optional
  depends_on "python" => :optional
  depends_on "rrdtool" => :optional
  depends_on "rsyslog" => :optional
  depends_on "tcc" => :optional
  depends_on "v8" => :optional
  depends_on "zeromq" => :optional
  depends_on "yajl" if build.without? "jansson"

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

    json = build.with?("jansson") ? "jansson" : "yajl"
    yaml = build.with?("libyaml") ? "libyaml" : "embedded"

    (buildpath/"buildconf/brew.ini").write <<~EOS
      [uwsgi]
      ssl = true
      json = #{json}
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

    plugins << "alarm_xmpp" if build.with? "gloox"
    plugins << "emperor_mongodb" if build.with? "mongodb"
    plugins << "emperor_pg" if build.with? "postgresql"
    plugins << "ffi" if build.with? "libffi"
    plugins << "fiber" if build.with? "ruby"
    plugins << "gccgo" if build.with? "go"
    plugins << "geoip" if build.with? "geoip"
    plugins << "jvm" if build.with? "java"
    plugins << "jwsgi" if build.with? "java"
    plugins << "libtcc" if build.with? "tcc"
    plugins << "lua" if build.with? "lua@5.1"
    plugins << "mongodb" if build.with? "mongodb"
    plugins << "mongodblog" if build.with? "mongodb"
    plugins << "mongrel2" if build.with? "mongrel2"
    plugins << "mono" if build.with? "mono"
    plugins << "nagios" if build.with? "nagios"
    plugins << "pypy" if build.with? "pypy"
    plugins << "rack" if build.with? "ruby"
    plugins << "rbthreads" if build.with? "ruby"
    plugins << "ring" if build.with? "java"
    plugins << "rrdtool" if build.with? "rrdtool"
    plugins << "rsyslog" if build.with? "rsyslog"
    plugins << "servlet" if build.with? "java"
    plugins << "stats_pusher_mongodb" if build.with? "mongodb"
    plugins << "v8" if build.with? "v8"
    plugins << "xslt" if build.with? "libxslt"

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    python_versions = {
      "python"=>"python2.7",
      "python2"=>"python2.7",
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
