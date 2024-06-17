class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/ce/37/517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9/supervisor-4.2.5.tar.gz"
  sha256 "34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12"
  license "BSD-3-Clause-Modification"
  head "https://github.com/Supervisor/supervisor.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "114ed80c189bf19224311eb0bbd95769267b80327c8072f21c23802f377d665f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2873473b2f374c6918ba564f217a5251fa3b6d9a5510015ccbd5b8d027fb7dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2fbe86f0746425a1b24ef9524c553a41bb697174f6f02af721740834b7b37e"
    sha256 cellar: :any_skip_relocation, sonoma:         "01790650d680a9618c81cf4fadc932954ca60dfa4d55cbcef6739bb4021ab953"
    sha256 cellar: :any_skip_relocation, ventura:        "41c9b2f7cbe02d24eabaa4cbca4a63f6335d315b1d8a416f85a39941f4f815df"
    sha256 cellar: :any_skip_relocation, monterey:       "399bf9a900a4f198bba19ddcb9f70b7b0b1a8dc9bfd400ed2466a82a6551a62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e4e0ba7947159bb2c71d518062e0f79a12f54db62fe4aa3f9d5a627d1968fe6"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
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
