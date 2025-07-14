class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/ce/37/517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9/supervisor-4.2.5.tar.gz"
  sha256 "34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12"
  license "BSD-3-Clause-Modification"
  revision 2
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9dcc3c481ca0d17cd2aab91c2e158b4963d61e2927187a808233ce3bd7b314b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9dcc3c481ca0d17cd2aab91c2e158b4963d61e2927187a808233ce3bd7b314b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9dcc3c481ca0d17cd2aab91c2e158b4963d61e2927187a808233ce3bd7b314b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31421ef12c8a51e19c55f95207f952c493cfe0b4004fff4ab4cf1141e03adb79"
    sha256 cellar: :any_skip_relocation, ventura:       "31421ef12c8a51e19c55f95207f952c493cfe0b4004fff4ab4cf1141e03adb79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1edc0c343cff8df9ba55439d5404cccb3a8d7d0696e0e3eaad130c137e3c43ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edc0c343cff8df9ba55439d5404cccb3a8d7d0696e0e3eaad130c137e3c43ec"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
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
      pid = spawn bin/"supervisord", "--nodaemon", "-c", "sd.ini"
      sleep 3
      sleep 9 if OS.mac? && Hardware::CPU.intel?
      output = shell_output("#{bin}/supervisorctl -c sd.ini version")
      assert_match version.to_s, output
    ensure
      Process.kill "TERM", pid
    end
  end
end
