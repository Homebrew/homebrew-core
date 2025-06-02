class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.34.4",
      revision: "fbf767a62ce3222925ade0d1bacec05f684f792a"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "961556ed4004e9f02e15aecc09e33deefb6b639e65f7b2231e11741cf98b3fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "961556ed4004e9f02e15aecc09e33deefb6b639e65f7b2231e11741cf98b3fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "961556ed4004e9f02e15aecc09e33deefb6b639e65f7b2231e11741cf98b3fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "846a788b22cb3535efb981f1c29512b46305697390fd4f471b1f80396d27aa33"
    sha256 cellar: :any_skip_relocation, ventura:       "846a788b22cb3535efb981f1c29512b46305697390fd4f471b1f80396d27aa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f58df25a9c8e1ebe2781ed94d098a34540810de08baee3eb9776b04fb9594bd"
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
