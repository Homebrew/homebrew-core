class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://sftpgo.com/"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.7.6/sftpgo_v2.7.6_src_with_deps.tar.xz"
  sha256 "f6da983e8d35bb698e4d8e99120a61cf0234f90eed396950bbee1a58d705cbad"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "a3a00bf433093cb5faa7057aafba86a792c6537b30657acdae05a2e5fbaf79f6"
    sha256 arm64_tahoe:       "aab385c3774b92982d03b410320214dad0a8a1702b985bdb0aad9c611b083352"
    sha256 arm64_sequoia:     "37dfa01a4bc2c0a398fb1dabd860169b270a606e811789efc9c14a33d9a7e6c1"
    sha256 arm64_linux:       "6822969bb3d07c9fdb89b6f7325c9979548d9cc5f058055cd9c3066fe159cbee"
    sha256 x86_64_linux:      "40f89cce30713c6eda608457fcbe1a59ff0c078ddc406b027c684ef24345aeb2"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
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
    pid = spawn bin/"sftpgo", "serve", "--config-file", "#{pkgetc}/sftpgo.json"

    sleep 5
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}/healthz")
    system "ssh-keyscan", "-p", sftp_port.to_s, "127.0.0.1"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
