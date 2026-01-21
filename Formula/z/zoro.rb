class Zoro < Formula
  desc "Expose local server to external network"
  homepage "https://github.com/txthinking/zoro"
  url "https://github.com/txthinking/zoro/archive/refs/tags/v20240828.tar.gz"
  sha256 "8b41550a1d42fa2c0a67d7115978efff126ab6fff30d774ce902febd0b682c5c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8cf70a14160538590d696a97a39afbfb1d69d238b808cc0b4392f94313e25b17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f74a1978da2e5be1134fe0b9dfcaf82794b27b2ed4dec8cabf74e0771a5588d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, ventura:        "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d47a3d2615ce498757d5ff686cff5e72d2e57a432aa008bc6026669c529450e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd81e60c2c5cd3b30aaa7f8dc372f435a73ff8cb765f77a04c0fb9fc0c3874ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/zoro"
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!DOCTYPE HTML>
      <html>
      <body>
        <p>passed</p>
      </body>
      </html>
    HTML
    zoro_server_port = free_port
    server_port = free_port
    client_port = free_port
    server_pid = spawn bin/"zoro", "server", "-l", ":#{zoro_server_port}", "-p", "password"
    sleep 5
    client_pid = spawn bin/"zoro", "client", "-s", "127.0.0.1:#{zoro_server_port}",
                                             "-p", "password",
                                             "--serverport", server_port.to_s,
                                             "--dir", testpath,
                                             "--dirport", client_port.to_s
    sleep 3
    output = shell_output "curl 127.0.0.1:#{server_port}"
    assert_match "passed", output
  ensure
    Process.kill "SIGTERM", server_pid, client_pid
  end
end
