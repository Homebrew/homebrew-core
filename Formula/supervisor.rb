class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://github.com/Supervisor/supervisor/archive/3.3.3.tar.gz"
  sha256 "cb835ee21a755d32396f5ccb40daa4ce8bb4a24d92f8bf3f25d3a76ba2fb0bc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a28dac5c49e52235bf1034526a11cae4adf7039bad16b4319e08e22a2afe8db0" => :sierra
    sha256 "08384975b991dbf8ff983fa99aa770ea33e6589d97d84a478a2564ca1d000f32" => :el_capitan
    sha256 "a442b4794e8962e05e667388cf12e7abe0df91c1803e93075d8aed06a4964b82" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "meld3" do
    url "https://files.pythonhosted.org/packages/45/a0/317c6422b26c12fe0161e936fc35f36552069ba8e6f7ecbd99bbffe32a5f/meld3-1.0.2.tar.gz"
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

    virtualenv_install_with_resources

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

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  test do
    (testpath/"sd.ini").write <<-EOS.undent
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
