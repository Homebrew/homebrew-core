class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/ce/37/517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9/supervisor-4.2.5.tar.gz"
  sha256 "34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12"
  license "BSD-3-Clause-Modification"
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff8c113fa52ad7fcfdd63fbcc761809f5e27afd73b9ad9f09a1771d7dcae16eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379f1c1e3a7f699ee93c23ec56ea88aa521e07bd57c872794d9a84f31a079d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4d870e085e652b0d20ba483013e960556df58032111db255056d3c469c9e22"
    sha256 cellar: :any_skip_relocation, sonoma:         "5733f2279479f146558632128ac2e09c0f8679d669d1dcc0eca2227e61410c74"
    sha256 cellar: :any_skip_relocation, ventura:        "bdafd39efc94ca15c14d1c8cc27637c88de5b346b097d4bed01a8be68b27bd14"
    sha256 cellar: :any_skip_relocation, monterey:       "6261dc4b3b8b532f362ab3f13009a78fc3e1b4079e0cd5bc58c0cc7dac2c70b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c5f62ca8dc1b0d9643a120ea346c9b5206a726fe8c27de63321e2c9cb2666a"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"

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
