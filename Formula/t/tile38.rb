class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.35.0",
      revision: "30f6a676b18349dcbecab4016455829de0dd087c"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fdff086d55c1811be9e97a252c90100393733532434fa91c04b730dfe5c7ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fdff086d55c1811be9e97a252c90100393733532434fa91c04b730dfe5c7ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fdff086d55c1811be9e97a252c90100393733532434fa91c04b730dfe5c7ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe479e461d6bafa81f058b0ddb585f2b5d1232742f5e90a38234295b78bc96b4"
    sha256 cellar: :any_skip_relocation, ventura:       "fe479e461d6bafa81f058b0ddb585f2b5d1232742f5e90a38234295b78bc96b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b52c220b7d853848568f327163a373164c9209f9ed2c4240d10113a2c84c472"
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
