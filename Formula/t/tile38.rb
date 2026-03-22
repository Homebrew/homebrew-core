class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.37.0",
      revision: "48aa3d2f303447513bbc9dc06dedac42269f4ad2"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdfe9e42cb4b5cdee808dfca100d20e9f04cf737d63aab45a2e9dc349647a73d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461aeac2ab719a07e5764dd88bc99352d36def813fe30c295e00c947deb5d2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bddb54ad65fd35534c8d593a6ede162d91a3dfb924a71e0201928d25083622d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce1a1638aa31d0f28e1e031937ac48f6e7588cd6542cb3bea43bf8ffbc18d79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4a22c1843a3dbca44783a1443386bc513efef0632ff31e2f2368c888c678aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9af0c425459875d1402d52e8c4b3ba93d69c1b733c1554791e9640ca6b012d3"
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
