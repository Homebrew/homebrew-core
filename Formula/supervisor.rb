class Supervisor < Formula
  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://github.com/Supervisor/supervisor/archive/3.3.0.tar.gz"
  sha256 "972a9a0f8738a62d166217ec8b8cdd8fdd23f6b1717dd2623512af72d9913f6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "db469509022bfdecc797fb411a46bf2cce69076be6f502b2aeb9041b55c71b70" => :el_capitan
    sha256 "35f28c23c178ed3a57b4a11e91747f8f969309e97c14a379dbb0e651436f7804" => :yosemite
    sha256 "fa259b39335b7f4b788ffc0a5625a3da9417afbb88ed9b1dc869c14710d5e791" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "meld3" do
    url "https://pypi.python.org/packages/source/m/meld3/meld3-1.0.2.tar.gz"
    sha256 "f7b754a0fde7a4429b2ebe49409db240b5699385a572501bb0d5627d299f9558"
  end

  def install
    inreplace buildpath/"supervisor/skel/sample.conf" do |s|
      s.gsub! %r{/tmp/supervisor\.sock}, var/"run/supervisor.sock"
      s.gsub! %r{/tmp/supervisord\.log}, var/"log/supervisord.log"
      s.gsub! %r{/tmp/supervisord\.pid}, var/"run/supervisord.pid"
      s.gsub! /^;\[include\]$/, "[include]"
      s.gsub! %r{^;files = relative/directory/\*\.ini$}, "files = #{etc}/supervisor.d/*.ini"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("meld3").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # For an explanation, see https://github.com/Supervisor/supervisor/issues/608.
    touch libexec/"lib/python2.7/site-packages/supervisor/__init__.py"

    etc.install buildpath/"supervisor/skel/sample.conf" => "supervisord.ini"
  end

  plist_options :manual => "supervisord -c #{HOMEBREW_PREFIX}/etc/supervisord.ini"

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false />
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/supervisord</string>
            <string>--configuration</string>
            <string>#{etc}/supervisord.ini</string>
            <string>--nodaemon</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  test do
    (testpath/"supervisord.ini").write <<-EOS.undent
      [unix_http_server]
      file=supervisor.sock

      [supervisord]
      loglevel=debug

      [rpcinterface:supervisor]
      supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

      [supervisorctl]
      serverurl=unix://supervisor.sock
    EOS

    begin
      pid = fork do
        exec "#{bin}/supervisord", "--configuration", "supervisord.ini",
                                   "--nodaemon"
      end
      sleep 1
      assert_match(version.to_s,
                   shell_output("#{bin}/supervisorctl --configuration supervisord.ini version"))
    ensure
      Process.kill "TERM", pid
    end
  end
end
