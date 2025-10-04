class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.4",
      revision: "bcc6f75905c82c1dd9c7dcd94527d7500326667e"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55275672070b44bc51eb9a558666a2c1bd3f09198dbee5167ca83cb57a21401b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d11c902aab939999f0b5dd53f9648b427546ec8dc9d5bb149a2a693404013dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5726ed6a8bf99572cc38b3c753a0181263358f1f0dc3c662c225941a0bd147c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a80b80d3a86c968c9a59a1601b1ecffd3e4eb27858c9d321f401d45a94de50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ed97fbcb84ce5996f4e190e8462df41fb919fd7f1f7578cbd0b3be6d83b48c"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-server"), "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-cli"), "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  service do
    run [opt_bin/"tile38-server", "-d", var/"tile38/data"]
    keep_alive true
    working_dir var
    log_path var/"log/tile38.log"
    error_log_path var/"log/tile38.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_path_exists testpath/"data"
  ensure
    Process.kill("HUP", pid)
  end
end
