class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.27.1",
      revision: "3984a5d014760c51422b6b21ad2600041505889c"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883075f244280c6a3bf191e185628e6e7aeb70949da216883dbf0655afcf3163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3227b61bbcb634b252a8d72c32bb5dd3b4971f3cf5a5ce5cdf43c6f0c254647a"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab84435b7f52a4e30142c1cef3f9016fe8f60c1ee5c7c822be3360368f88424"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4f393cf0129302dbf23c81015fbb82151ccdce9b967533e95010fbb9aff957"
    sha256 cellar: :any_skip_relocation, catalina:       "fb809e5113e8ab05cb0dcc109112e0046d62eb804b090e837718915fa330e39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb7da50e1957302534a1c230a3d073540ed950e9e89bde70de133e81ba3ca00"
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
