class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://github.com/DatanoiseTV/tinyice"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "5ce3e9ccf314cb57dc56fe78d82563cef97ddab4d4f60f36329f324130ccf3a6"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "920e6d89e528556e5a59462dcf23a7483517e339badde64deda022320d27b531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920e6d89e528556e5a59462dcf23a7483517e339badde64deda022320d27b531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920e6d89e528556e5a59462dcf23a7483517e339badde64deda022320d27b531"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab8b239183e4d26f868e28e4956e7a5e8f2ebe7ea3b04037d79fb17ce3c4155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f159c201da0cc887dee355bd5acc6aea06034319391667404ac497e14b7f39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b55a9e19a75d29e6b76ff2dc637409c87229ec551069b2dd9e9b1f8a6c4f7b"
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
