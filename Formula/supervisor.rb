class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/b3/41/2806c3c66b3e4a847843821bc0db447a58b7a9b0c39a49b354f287569130/supervisor-4.2.4.tar.gz"
  sha256 "40dc582ce1eec631c3df79420b187a6da276bbd68a4ec0a8f1f123ea616b97a2"
  license "BSD-3-Clause-Modification"
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8eb69708ed6b2df4573ef41288d3a16b48540c4436508f8d513050e0e9d9671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8eb69708ed6b2df4573ef41288d3a16b48540c4436508f8d513050e0e9d9671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8eb69708ed6b2df4573ef41288d3a16b48540c4436508f8d513050e0e9d9671"
    sha256 cellar: :any_skip_relocation, ventura:        "67f3ae8029a4eadc49e9dde99abe66221f6a380f86991ecd4f386dd350d67c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "67f3ae8029a4eadc49e9dde99abe66221f6a380f86991ecd4f386dd350d67c5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "67f3ae8029a4eadc49e9dde99abe66221f6a380f86991ecd4f386dd350d67c5e"
    sha256 cellar: :any_skip_relocation, catalina:       "67f3ae8029a4eadc49e9dde99abe66221f6a380f86991ecd4f386dd350d67c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caee84afcfdf07a9c03f4db8981bc9b9c9f29dd61032e4717adb4fc5a6da81fd"
  end

  depends_on "python@3.11"

  def install
    inreplace buildpath/"supervisor/skel/sample.conf" do |s|
      s.gsub! %r{/tmp/supervisor\.sock}, var/"run/supervisor.sock"
      s.gsub! %r{/tmp/supervisord\.log}, var/"log/supervisord.log"
      s.gsub! %r{/tmp/supervisord\.pid}, var/"run/supervisord.pid"
      s.gsub!(/^;\[include\]$/, "[include]")
      s.gsub! %r{^;files = relative/directory/\*\.ini$}, "files = #{etc}/supervisor.d/*.ini"
    end

    virtualenv_install_with_resources

    etc.install buildpath/"supervisor/skel/sample.conf" => "supervisord.conf"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
    conf_warn = <<~EOS
      The default location for supervisor's config file is now:
        #{etc}/supervisord.conf
      Please move your config file to this location and restart supervisor.
    EOS
    old_conf = etc/"supervisord.ini"
    opoo conf_warn if old_conf.exist?
  end

  service do
    run [opt_bin/"supervisord", "-c", etc/"supervisord.conf", "--nodaemon"]
    keep_alive true
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
