class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.5",
      revision: "0b31bf10dfcfcbe1044a2e74e86a7e40cd72f82d"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38d712a280230b6b1538b048ac3ef9e5c864d494a7d60f199f05709b402352d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eded5b6ac9b6aa2526075c77c7734b3cd6bf5045db47ef6a2d50e1b7d8d2c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a35ae950df7ae0b72324f02e1ce2409e4f972af0ce6aa358f4741c76c0e814"
    sha256 cellar: :any_skip_relocation, sonoma:        "e652ede6b01113108a682c4c67fc55ee2363bd57c589423de1e924e040f0ea95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c0bc67fcec2a39503dbc67ae7f9822caf2959a0aaeccf7641a5e5e30776150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfcf855c247c549a077c6ca7187078618e739c8c0404c81a996cf19e0e428d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-server"), "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-cli"), "./cmd/tile38-cli"

    # Make sure the data directory exists
    (var/"tile38/data").mkpath
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
    pid = spawn bin/"tile38-server", "-q", "-p", port.to_s
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
