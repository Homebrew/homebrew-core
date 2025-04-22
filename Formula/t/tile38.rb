class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.34.3",
      revision: "0794ad766835eff2c0f7ef3d6e549763063af475"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee63c0da1934219deb28427bf003d7f0101c4e2d7e1c5c160fb45b3e4a7492a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee63c0da1934219deb28427bf003d7f0101c4e2d7e1c5c160fb45b3e4a7492a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ee63c0da1934219deb28427bf003d7f0101c4e2d7e1c5c160fb45b3e4a7492a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d80bad2dcfc1d33e11d28b98076416f5fd244b1373a712c3ae4f3f6d05cea6d"
    sha256 cellar: :any_skip_relocation, ventura:       "6d80bad2dcfc1d33e11d28b98076416f5fd244b1373a712c3ae4f3f6d05cea6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e95f8162bcdede2d7bc495fc46b0805015ebd587b4300031c0a326e3207d54"
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
