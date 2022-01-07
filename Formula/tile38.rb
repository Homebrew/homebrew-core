class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.27.1",
      revision: "3984a5d014760c51422b6b21ad2600041505889c"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6eb24e275ac68ff8f9003e55ebd1a5e8bcfd31761467c8986e206be5f663db0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a364553308228a24ef58c64e0fc1257fb06746515df177e29096f940b30748a"
    sha256 cellar: :any_skip_relocation, monterey:       "47b946608e85deeebf595fbfcee4242c3600261e0076ff075d4d3b5619f4ccd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "71346c62d18a072317e320ec3606ddafe299d22139ec788f03ab1ec215328d00"
    sha256 cellar: :any_skip_relocation, catalina:       "2cc086c271439fa187a9f1f67563859ed50da4ee85197ce26db67412bc152566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b14524e414051d374f85d09ed118ebef0f25e1e03452a46b4aadd076ce55b4"
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
