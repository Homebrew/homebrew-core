class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.4.2/sftpgo_v2.4.2_src_with_deps.tar.xz"
  sha256 "363e087599654385a6f8a4ffcf42b458301bc0c74b8aa35e13cc886b19948d19"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "a564fb2bc59f2ad85082c3e19ee8d599997b3c32077c5effb464a6cc5db48b7f"
    sha256 arm64_monterey: "87493302adb7f58824ed728202718f4f4560c4d3c33964a61f2275eb23ed2c67"
    sha256 arm64_big_sur:  "7d59506fd1d00fe946ecc5846817b4438fcd40a297b34ede8a4fd4f1fd7dc844"
    sha256 monterey:       "08c663acded2fca541ba8109292de2af800bd914dce10a69cc3b9d1b9b461648"
    sha256 big_sur:        "a66d60235369b96a4abb59c0cba129a6a281fd5569e40202a340f36e3563ecf2"
    sha256 catalina:       "49ffc3af2b7016f1ffe27ef4786f235380296a86257b2ad35353988dae4c628a"
    sha256 x86_64_linux:   "2c553bf41f6aa4582bbfd4654cba74880a1544a789345f3144b2185f7ef7450d"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "nopgxregisterdefaulttypes"
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
