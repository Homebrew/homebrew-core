class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.3",
      revision: "d95935124a974dba03f2fa4bc7ee32e9d84ad9e9"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b9c411ceb4f0bcc9c6510dee2881f4ddb80dc2a6722a8f031e0c28bc2d92999"
    sha256 cellar: :any_skip_relocation, big_sur:       "53aad82fed795c0085165df45840315fdd38d17cefa57cfc957c9ca2ff2bcb6c"
    sha256 cellar: :any_skip_relocation, catalina:      "2449552776f98aebb91a1e5038b29036ddc75beb08672d3c3c9dda8b4d6e81a6"
    sha256 cellar: :any_skip_relocation, mojave:        "97a60bcad34e72a18e6464cdddad8518055dd5c2291df166769ee194a55fe7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02af46131d3038a198492ee11f353b7fdf8a7da424c9abd7ecf85c8f7752a688"
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
