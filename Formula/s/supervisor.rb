class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http://supervisord.org/"
  url "https://files.pythonhosted.org/packages/a9/b5/37e7a3706de436a8a2d75334711dad1afb4ddffab09f25e31d89e467542f/supervisor-4.3.0.tar.gz"
  sha256 "4a2bf149adf42997e1bb44b70c43b613275ec9852c3edacca86a9166b27e945e"
  license "BSD-3-Clause-Modification"
  head "https://github.com/Supervisor/supervisor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94a5fa21547627537c69f8b8ebaa5f27072b8306769495d076080f235c7b9f8"
    sha256 cellar: :any_skip_relocation, ventura:       "c94a5fa21547627537c69f8b8ebaa5f27072b8306769495d076080f235c7b9f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a68ce041e29ddbb3243a78077da5b7319335b708c7269c17101e22bad70c6b"
  end

  depends_on "python@3.13"

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
