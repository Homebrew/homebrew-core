class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.6.2/sftpgo_v2.6.2_src_with_deps.tar.xz"
  sha256 "c90260b7b2901438bbd476eee9fd389af5af24113088a50284b2d170631b52ee"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_sequoia:  "378ab577341c52eade15262dea2426ff3c848a29bf658ff115df5174e449b48d"
    sha256 arm64_sonoma:   "ccf55eb1dc3f3fc0cff3eec784367dae7f43637c2afd8d93eb595fa3ceb37bd9"
    sha256 arm64_ventura:  "348636fa1e3f7ccbb067c36bf8fc666b0c1dca2f78480a1fa6f4452d622abb26"
    sha256 arm64_monterey: "daac16c36497a50b27b11a3f1051d460852a7e801349eca53770e6483c5f3f63"
    sha256 sonoma:         "ac68526787858a734993736e7a7ec14ad1917e013fb91b6a09210a919628232e"
    sha256 ventura:        "dd3d8bcc33b6137d0d3b8790da3bddbf03b5491808bcc0ca28b161c29881e9bf"
    sha256 monterey:       "a5e96caf5cacd56399c15b2f331a77fdf6e7de263b676528eeb7df5b3b107057"
    sha256 x86_64_linux:   "bf3f1ff033fa8807ccfd4cda40c4d5f1b726f84c3b5fad6f3ddc6786a6f43053"
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
