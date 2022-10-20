class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.29.1",
      revision: "a490f09a24c370e590c55e0a06531501fd50a173"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac773555ffbe57a8029715632ace7ef60a1caf291886741173e88a50c17e0f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb4b74ac824f24afd92844e238df90e2d855336723a52b02d8d40617757732a"
    sha256 cellar: :any_skip_relocation, monterey:       "f133a3e3bbede843b736b46035db6dc9ade1ef28bd0d75f9822cbf4d7140457d"
    sha256 cellar: :any_skip_relocation, big_sur:        "be818cc3ea89aeb734d40be8b674fdf0ce855da49a97d8df76578c5300c293c9"
    sha256 cellar: :any_skip_relocation, catalina:       "30b2c2e275ed2a5672035a51c5013d2786f2982c1ec6823e1dce19c4389f6d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b093191eefda5a79086e282c327e02ee96c056a9848a7c552f991b61ea7096"
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
