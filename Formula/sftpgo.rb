class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.3.1/sftpgo_v2.3.1_src_with_deps.tar.xz"
  sha256 "dd4d0f7b7e7618f01ccecee7ea8045a6adcee2c2e29ab011a85eef8c80a0ac55"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4177c93da29157f3326598a85e3a1c7129c880a80092d7bf90f4a98755134f52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb7138ee760de736f3920c7660bad35c87a3b504f1a491c88ab7fcc173698168"
    sha256 cellar: :any_skip_relocation, monterey:       "4779a81233db43db1a3b6296d365709c35f5d9eb0f6938a1670090669e9cb486"
    sha256 cellar: :any_skip_relocation, big_sur:        "afb296aefe068d09e4619b12d728bb84599b8e07cd45b9f5b4c2a03078ec4f11"
    sha256 cellar: :any_skip_relocation, catalina:       "bb0e5ce46d2ffb4f33975946ac61b72b9130d5719d76576ba387053efbd7ff63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d009a58901d01a7b9599f9bc81f012ba9426f9ffc10a41ce186b440dc5bc0456"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/util.additionalSharedDataSearchPath=#{opt_pkgshare}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
    system bin/"sftpgo", "gen", "man", "-d", man1

    (zsh_completion/"_sftpgo").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "zsh")
    (bash_completion/"sftpgo").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "bash")
    (fish_completion/"sftpgo.fish").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "fish")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json
    EOS
  end

  plist_options startup: true
  service do
    run [bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
         var/"sftpgo/log/sftpgo.log"]
    keep_alive true
    working_dir var/"sftpgo"
  end

  test do
    expected_output = "ok"
    http_port = free_port
    sftp_port = free_port
    ENV["SFTPGO_HTTPD__BINDINGS__0__PORT"] = http_port.to_s
    ENV["SFTPGO_HTTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__BINDINGS__0__PORT"] = sftp_port.to_s
    ENV["SFTPGO_SFTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__HOST_KEYS"] = "#{testpath}/id_ecdsa,#{testpath}/id_ed25519"
    ENV["SFTPGO_LOG_FILE_PATH"] = ""
    pid = fork do
      exec bin/"sftpgo", "serve", "--config-file", "#{pkgetc}/sftpgo.json"
    end

    sleep 5
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}/healthz")
    system "ssh-keyscan", "-p", sftp_port.to_s, "127.0.0.1"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
  end
end
