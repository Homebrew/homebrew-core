class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://sftpgo.com/"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.7.5/sftpgo_v2.7.5_src_with_deps.tar.xz"
  sha256 "2c7eb3a01c6a2dc67d13408302428a056032e42d57bbb74ba92ac24f68f35aff"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_tahoe:   "607f9998c1da9a53ac0fadc8a446b9f67c13b3fdbec7f89e18e50f9d4aff9426"
    sha256 arm64_sequoia: "11da1147e3bdbf666efb6a72330329f1f5536ef85ea5d4e18d567dd8d9a8edf6"
    sha256 arm64_sonoma:  "f35001f697e3a90747043687ee5225fa761553bac23f35d44bebcad20bba755a"
    sha256 sonoma:        "4d7ab634713e677e161a760b47273d9d4c071665da2ab953eb909026c9d6e8d2"
    sha256 arm64_linux:   "5ec906426ccb8cd02a3201fd86abe773a8e49cf85aa98d39c9b990daafd12f5f"
    sha256 x86_64_linux:  "edb38eb39c753b69796c9d82387c222f2f3ef241017d76fc5bb5afa72cbf5a98"
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
