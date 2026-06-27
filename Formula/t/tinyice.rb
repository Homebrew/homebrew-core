class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "24ced8022e42f900ada1471d7152dcc43552d8bce022efe216a7fa5eb5a55fcd"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445bec3d63ab9aec24b3fe66e8fb9a24df02f098c764256a2caa29641d3d2005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445bec3d63ab9aec24b3fe66e8fb9a24df02f098c764256a2caa29641d3d2005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445bec3d63ab9aec24b3fe66e8fb9a24df02f098c764256a2caa29641d3d2005"
    sha256 cellar: :any_skip_relocation, sonoma:        "28de2be722f39d7ad03587da88b8f962c9cc38dff00ca46ccefdfeb9ad058100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed3e13c5bcc440427c3d077b8401828fb8d812f2ec7b213c66b8b71e899be032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5feef288d107607ab327956c7c178e7e69d02b0190996954edadd785ae43f867"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"tinyice"]
    keep_alive true
    working_dir var/"tinyice"
    log_path var/"log/tinyice.log"
    error_log_path var/"log/tinyice.log"
  end

  test do
    port = free_port

    # Write minimal config
    (testpath/"tinyice.json").write <<~JSON
      {
        "bind_host": "127.0.0.1",
        "port": "#{port}",
        "admin_user": "admin",
        "admin_password": "test"
      }
    JSON

    pid = spawn bin/"tinyice", chdir: testpath
    sleep 3

    begin
      output = shell_output("curl -s --fail http://127.0.0.1:#{port}/")
      assert_match("TinyIce", output)
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
