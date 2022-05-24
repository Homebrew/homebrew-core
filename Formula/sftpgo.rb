class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.2.3/sftpgo_v2.2.3_src_with_deps.tar.xz"
  sha256 "6c8676725e86ee3f6ad46a340a84f0da37cab8b6ea7b6aee86b2b96ba5e6671a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6878f05cd56dd09aa7fdcf2d624291ff812905538688fd63ccebc692fe42289b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "601e0bad5d9bbe2286660f01e3194e3f6bc4d28e143e46e8315ae052e7dccde9"
    sha256 cellar: :any_skip_relocation, monterey:       "84277342de48e7f330a4c259cc36f77fab97d1709fae3d30168e4e769c7ac599"
    sha256 cellar: :any_skip_relocation, big_sur:        "664d7602fb45d8aed5946864851ec822fb0a78b2e204cf7e921c79ea9985caac"
    sha256 cellar: :any_skip_relocation, catalina:       "a78ee9ebc9e3f6780198057bf5b691014ecadcf7ac621b3bcdd3fd5c0ece02f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4bfe51b971dd79dc4807f3266e5971f33c119d85b93dc7d5ce3b284b951374"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin/"sftpgo", "gen", "man", "-d", man1

    (zsh_completion/"_sftpgo").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "zsh")
    (bash_completion/"sftpgo").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "bash")
    (fish_completion/"sftpgo.fish").write Utils.safe_popen_read(bin/"sftpgo", "gen", "completion", "fish")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
      s.gsub! "\"templates_path\": \"templates\"", "\"templates_path\": \"#{opt_pkgshare}/templates\""
      s.gsub! "\"static_files_path\": \"static\"", "\"static_files_path\": \"#{opt_pkgshare}/static\""
      s.gsub! "\"openapi_path\": \"openapi\"", "\"openapi_path\": \"#{opt_pkgshare}/openapi\""
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
    ENV["SFTPGO_LOG_FILE_PATH"] = "#{testpath}/sftpgo.log"
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
