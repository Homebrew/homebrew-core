class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/d3/7f/c780b7471ba0ff4548967a9f7a8b0bfce222c3a496c3dfad0164172222b0/supervisor-4.2.2.tar.gz"
  sha256 "5b2b8882ec8a3c3733cce6965cc098b6d80b417f21229ab90b18fe551d619f90"
  license "BSD-3-Clause-Modification"
  revision 1
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ca7572ee9fed86ba1cc5ad5c4ffe0df7f094307e78b623d75dea464b274592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19ca7572ee9fed86ba1cc5ad5c4ffe0df7f094307e78b623d75dea464b274592"
    sha256 cellar: :any_skip_relocation, monterey:       "03bb01ee8b90ea72e8d5fd27994f7b5e002576b467bdda3b6011e8af63d9777e"
    sha256 cellar: :any_skip_relocation, big_sur:        "03bb01ee8b90ea72e8d5fd27994f7b5e002576b467bdda3b6011e8af63d9777e"
    sha256 cellar: :any_skip_relocation, catalina:       "03bb01ee8b90ea72e8d5fd27994f7b5e002576b467bdda3b6011e8af63d9777e"
    sha256 cellar: :any_skip_relocation, mojave:         "03bb01ee8b90ea72e8d5fd27994f7b5e002576b467bdda3b6011e8af63d9777e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af1065b2eca37b2678c416ec8274516fe1989b1d60debfc5057464f2f07fa84e"
  end

  depends_on "python@3.10"

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
