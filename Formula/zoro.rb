class Zoro < Formula
  desc "Expose local server to external network"
  homepage "https://github.com/txthinking/zoro"
  url "https://github.com/txthinking/zoro/archive/v20211230.tar.gz"
  sha256 "5e78704f4d955cc4fd6dcc3395392e52516f00296cb65454f6959d4b7b54e319"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1494b28b437b7a43938455261dd3ec5f118d9f45ef85124893da72b948f57413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a527ad3a8feeb3f659d75f0146843339e4377a63a72cd14e987c77bbebd3647"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62e51e52666b734d3ab5bf05d39f2af1fa5bc657cc96c5c34e25fcddc2e0689c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f4b199fb8f35aaac204ae34d44c0df3d596b982d2adc50d2b3799b418bad6ef"
    sha256 cellar: :any_skip_relocation, monterey:       "93d7641309e5826897e9407ed9f528240c68a22d7a8f0ac272321078718477fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbb86277a41769277b24643ec1b19652ab615b40d0760023477530a928535e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b018bcf6de41f3323380fe85ba6181e26540c61a46b9faa28a3fd845e04855a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5c2f190710ef2be7b10d20f89d3db1cecdad89ed9fc40e3de57e0aebdcad01"
  end

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
