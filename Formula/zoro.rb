class Zoro < Formula
  desc "Expose local server to external network"
  homepage "https://github.com/txthinking/zoro"
  url "https://github.com/txthinking/zoro/archive/v20211230.tar.gz"
  sha256 "5e78704f4d955cc4fd6dcc3395392e52516f00296cb65454f6959d4b7b54e319"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/zoro"
  end

  test do
    (testpath/"index.html").write <<~EOF
      <!DOCTYPE HTML>
      <html>
      <body>
        <p>passed</p>
      </body>
      </html>
    EOF
    zoro_server_port = free_port
    server_port = free_port
    client_port = free_port
    server_pid = fork { exec bin/"zoro", "server", "-l", ":#{zoro_server_port}", "-p", "password" }
    sleep 5
    client_pid = fork do
      exec bin/"zoro", "client", "-s", "127.0.0.1:#{zoro_server_port}",
                                "-p", "password",
                                "--serverport", server_port.to_s,
                                "--dir", testpath,
                                "--dirport", client_port.to_s
    end
    sleep 3
    output = shell_output "curl 127.0.0.1:#{server_port}"
    assert_match "passed", output
  ensure
    Process.kill "SIGTERM", server_pid, client_pid
  end
end
