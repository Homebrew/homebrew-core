class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://github.com/Supervisor/supervisor/archive/4.2.0.tar.gz"
  sha256 "05031f36ad15cad47fb56f01d8e075f952ae39ba8ce492ea790ebb310e3f0368"

  bottle do
    cellar :any_skip_relocation
    sha256 "51effbdc862aa25784afe39cf8bc8d8c00cec6e2b16666a6f29ca8834119731b" => :catalina
    sha256 "0462b3c5acf4292902d25aa6d2706c1803696fbfea3a74b3eac6e5b65dc44228" => :mojave
    sha256 "d842313361e1c465bcd8813c490aefcb19071bf55629414f0117c74c92d7c2b3" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    inreplace buildpath/"supervisor/skel/sample.conf" do |s|
      s.gsub! %r{/tmp/supervisor\.sock}, var/"run/supervisor.sock"
      s.gsub! %r{/tmp/supervisord\.log}, var/"log/supervisord.log"
      s.gsub! %r{/tmp/supervisord\.pid}, var/"run/supervisord.pid"
      s.gsub! /^;\[include\]$/, "[include]"
      s.gsub! %r{^;files = relative/directory/\*\.ini$}, "files = #{etc}/supervisor.d/*.ini"
    end

    virtualenv_install_with_resources

    etc.install buildpath/"supervisor/skel/sample.conf" => "supervisord.ini"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  plist_options :manual => "supervisord -c #{HOMEBREW_PREFIX}/etc/supervisord.ini"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/supervisord</string>
            <string>-c</string>
            <string>#{etc}/supervisord.ini</string>
            <string>--nodaemon</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"sd.ini").write <<~EOS
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
      pid = fork { exec bin/"supervisord", "--nodaemon", "-c", "sd.ini" }
      sleep 1
      output = shell_output("#{bin}/supervisorctl -c sd.ini version")
      assert_match version.to_s, output
    ensure
      Process.kill "TERM", pid
    end
  end
end
