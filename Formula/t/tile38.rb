class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.32.0",
      revision: "2b2be89ef80ecf2aaf25b68aa6357c8dbd6bff17"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "536202f0689c5bdf1bb8b0b7d7782e0b4a1dd66852313125b184fb290aab7b0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536202f0689c5bdf1bb8b0b7d7782e0b4a1dd66852313125b184fb290aab7b0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "536202f0689c5bdf1bb8b0b7d7782e0b4a1dd66852313125b184fb290aab7b0b"
    sha256 cellar: :any_skip_relocation, ventura:        "f379f070ea288b4eebffca8ec565c66b8aeb7221c8785ded1c9412065f8ac0a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f379f070ea288b4eebffca8ec565c66b8aeb7221c8785ded1c9412065f8ac0a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f379f070ea288b4eebffca8ec565c66b8aeb7221c8785ded1c9412065f8ac0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d57d4e5a55b99e6a96e0618e1f070d1e8da753b1baa68e11bf1adb62bea81e9"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
