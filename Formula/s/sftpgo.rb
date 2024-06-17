class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.6.0/sftpgo_v2.6.0_src_with_deps.tar.xz"
  sha256 "13699ff48204610b1c0d01241963e7adb3f3fa1540b060a9d3ab963d8a109953"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sonoma:   "051b04593f6fcf6d1fee9fb61df4cd66cbef2af8b1c4080b49e2bf8b8d6c40fa"
    sha256 arm64_ventura:  "2b78f3f5d9bfadd2c9b6bb1dcfd3b7557bda24a2adc2f35a199d94716d551e73"
    sha256 arm64_monterey: "b582dd2b0be30d4dd2022f733bc5dcbd744e9aba1970dfe4ceaef0f4f844751c"
    sha256 sonoma:         "180a45a1f382e04c05743ad9bf59c19232f2eb1bfd640604c9096aeabc72f92b"
    sha256 ventura:        "a14b73a96d9c91e2086c4310dc379d6d54275bf71d2b688cbd84df300a5de015"
    sha256 monterey:       "470646aca7901e911af0172432f895737261f0978b7381dd71cac3c79124e13a"
    sha256 x86_64_linux:   "a1188559c8723807502d31716676a59cb9b5b78c7c273d7ac73e1ce38eba7eef"
  end

  depends_on "go" => :build

  def install
    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/internal/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/internal/version.commit=#{git_sha}
      -X github.com/drakkan/sftpgo/v2/internal/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:), "-tags", "nopgxregisterdefaulttypes"
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
