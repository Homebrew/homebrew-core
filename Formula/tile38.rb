class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.30.2",
      revision: "ae3e549cfc5ead8cdd792c14d553e21401c36cbb"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d704bf89b40b03a39643ac2276799fd274b142f716345bbdf0e6e4afbf539dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d74675562141e2f890de61f7f38a052d7bbd8da302632d3cbf74c277ea3d76cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2a9717eb8c5a30eccc46514452c601652b44024476b6f0a7d764cc83bd17391"
    sha256 cellar: :any_skip_relocation, ventura:        "f8dc85420680aba11af689e1cbe0c1b8d1771814bf0931257ab10cf80e56584f"
    sha256 cellar: :any_skip_relocation, monterey:       "4117611ebf34c732be2de2498aa14b3276c59da737179d3de16966db3845603b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b02c2a508b38e4ce9d1d329873e12921880899a06c5841ebec7157de730ad0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eef6ef6c541a5740e63661b0c0d44b358ec82a5582bd97a7da3d99308870e5e"
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
