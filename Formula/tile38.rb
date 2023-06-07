class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.31.0",
      revision: "b96322a0428c55373d22d0c118ee03decb95a4fc"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6942b1619df8086ad53b886f4d7a4381a9d98c3db0f0c8bede71aa241f120bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6942b1619df8086ad53b886f4d7a4381a9d98c3db0f0c8bede71aa241f120bf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6942b1619df8086ad53b886f4d7a4381a9d98c3db0f0c8bede71aa241f120bf4"
    sha256 cellar: :any_skip_relocation, ventura:        "165ee1e18d9b4c1bfbbd8af011a912787ad4a6bde1b492d312c9f63f96dee8fa"
    sha256 cellar: :any_skip_relocation, monterey:       "165ee1e18d9b4c1bfbbd8af011a912787ad4a6bde1b492d312c9f63f96dee8fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "165ee1e18d9b4c1bfbbd8af011a912787ad4a6bde1b492d312c9f63f96dee8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d89571b41aa4f393adff401db4c2da989d7bbae4c1c95aa8f9dc61b062ab19"
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
