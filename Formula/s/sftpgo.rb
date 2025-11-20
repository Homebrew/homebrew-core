class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://sftpgo.com/"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.7.0/sftpgo_v2.7.0_src_with_deps.tar.xz"
  sha256 "7d70361aa52857816d2c14ff8b306429476f0864a10d99d9139b6ef1a8aaa45e"
  license "AGPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "a2c5a58f6786fa00d6088cf3aa6d4a18633f86b7c1af5111a7c720ea6982f741"
    sha256 arm64_sequoia: "cfb4dfe0a2167c8a17d3639dc4075af9cab077201207bf4da95ae961b6d25205"
    sha256 arm64_sonoma:  "c8a8b19dadf5f89d7ad6ad1a8fcdd21e2846dc3de1cfa5791c4872dd8b5019ba"
    sha256 sonoma:        "2ad06c7ac8a561cc2a7db80ba4bc7854519e5dd29d06ca48b77e1dd288b9e1ff"
    sha256 arm64_linux:   "a2055c3947c346d8dfa56a4908da3abfdb635b12883c0ebb7439c1fa9b09a215"
    sha256 x86_64_linux:  "58b43409163f36ca08dfda3966147fb3b9adc9b0c2e5ca9e11bffb651a7f02ae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/internal/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/internal/version.commit=#{git_sha}
      -X github.com/drakkan/sftpgo/v2/internal/version.date=#{time.iso8601}
    ]
    tags = %w[
      nopgxregisterdefaulttypes
      disable_grpc_modules
    ]
    system "go", "build", *std_go_args(ldflags:, tags:)
    system bin/"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin/"sftpgo", "gen", "completion")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
    (var/"sftpgo/env.d").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json
    EOS
  end

  service do
    run [opt_bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
         var/"sftpgo/log/sftpgo.log"]
    keep_alive true
    require_root true
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
