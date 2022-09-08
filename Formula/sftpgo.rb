class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo.git",
      tag:      "v2.3.4",
      revision: "df84c42e7e8a1675769fa9065b2781a6abc8ab1b"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/drakkan/sftpgo.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "39c85b9f0f992afa526afd6f0f09eac68a4d21d44648a8cf50a05951848139b6"
    sha256 arm64_big_sur:  "95f93afcb82eeba62263dedd7e258aa2bd86375f7c715984d9a39377587a19d1"
    sha256 monterey:       "77e15f5dd6fbc52db3456e1aa070e0bfa6bc30eb6b128cbf7a26f19989a85c19"
    sha256 big_sur:        "e1a16191ded1ffa35b1de6d14730bee4339be5a19bd7b359df1e8f312829d519"
    sha256 catalina:       "1f159f1919b4c19194b00c1337a3b320210513b0ed5a8ea37a4dc4ed7f709ef8"
    sha256 x86_64_linux:   "9ff1191524ff77b0a4e1148a7fbcf37f7b8e20daf37b5c3c65f48b530a4da38f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/version.commit=#{Utils.git_short_head(length: 8)}
      -X github.com/drakkan/sftpgo/v2/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
    system bin/"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin/"sftpgo", "gen", "completion")

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
