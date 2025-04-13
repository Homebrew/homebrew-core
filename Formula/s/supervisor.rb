class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/ce/37/517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9/supervisor-4.2.5.tar.gz"
  sha256 "34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12"
  license "BSD-3-Clause-Modification"
  revision 1
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd5d653ec9ae1a0db2ddca2a58d549ea9c48d4c15be4a11eb71b3aa9e555e872"
    sha256 cellar: :any_skip_relocation, ventura:       "dd5d653ec9ae1a0db2ddca2a58d549ea9c48d4c15be4a11eb71b3aa9e555e872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75da1e237c2fd2c1bf889e8556e482b4f79f4cfa724a42f86467e2278805300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f432821d07fd084494beb62d4f237950f1c9b640dabb6cb85a0d2fd8f6e0598"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

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
    (testpath/"sd.ini").write <<~INI
      [unix_http_server]
      file=supervisor.sock

      [supervisord]
      loglevel=debug

      [rpcinterface:supervisor]
      supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

      [supervisorctl]
      serverurl=unix://supervisor.sock
    INI

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
