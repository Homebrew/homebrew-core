class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.33.2",
      revision: "a953466318ce1d65a16259099a5b023650bfdf11"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66ff72e4032aa211be1173a923ac68f9daa367d1cefc9df4e745c02635603c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f6a68f961b3f7030636d733e044b0833ec28bd4236bb4421ca0e4b81ed96183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd1f437cc9ecafe562d8f0d07cb519542c6f02ea760ad34b83bbd8a2540009c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed920ec06fa86a0e159d29c2d13d5bfa54e9843b1b945d322a741aa06900f431"
    sha256 cellar: :any_skip_relocation, ventura:        "7735304e07eccf955a7ccdd32c179cec282eb26be81301a833f193a844b0beca"
    sha256 cellar: :any_skip_relocation, monterey:       "879b3c32fab2f0f954362ef46d6bb9ee0ed933bcd380825fefbc60556996f2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f3bc0698ba7e4b3a66cac5a6c7b6a640f6ab1a19923e6ebaab90bc80a9fb699"
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

    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
