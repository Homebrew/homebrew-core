class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://sftpgo.com/"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.6.6/sftpgo_v2.6.6_src_with_deps.tar.xz"
  sha256 "02d36a540e79ee877585c145cbe294bd48b03db98d2b577273cad4c8b6cf482c"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sequoia: "618de2bf3a3e61caeb84a818715060a7793e35dea8309b529c42715e10382778"
    sha256 arm64_sonoma:  "cf13ba2d5b0ef2cf8cc20ef3c6e7ba8719fcca93e88b545924ac0976dbc0d9bb"
    sha256 arm64_ventura: "f5b1195ebb945df9faa935aff174de9305be4e66deb7d015271255c23df2293c"
    sha256 sonoma:        "b0e1b0c942ab7489cae8fd45b1f8586ecccf2c9f95e08d3c21b762690e4af66e"
    sha256 ventura:       "b8be7324b8fc6d0ba8c3d833043f042cf0a161d4c31242686ef0915773aad7cd"
    sha256 arm64_linux:   "03ccf1abb305691c6d1c169fceaa36057810a6e2888baac8977ccb1ebfb6a90e"
    sha256 x86_64_linux:  "e1b0617a0ea156c8d4a002fbfdeb8d3b1fa448e8bb8167dd9c5f5f0934af1efc"
  end

  depends_on "go" => :build

  def install
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
