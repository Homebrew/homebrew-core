class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.3",
      revision: "01db1d1b6081ff4a6bda618f9b7815d02f79614b"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fff7450d812079c8243db54a69c2c9902af75da72a8f5403b7744005b3256c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81cc6a8a27e6975cd53ce45b59e46297d7a56242f86facb8cf6880a545e099c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90eec2cf4ca2e90692c45a37ad0055b745dd56cb8348a5c725ebe6d42030fbf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9e4b8f53cbc11a97823546c02edd44106b524d40a64814797c5aea9a963da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de130236283232f140fae754e14bb102dd84eb797bd3b272d66fc601caee1b76"
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
