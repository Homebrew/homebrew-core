class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.30.0",
      revision: "a09ff07c91f092febbe1e06c87108f6c670d07df"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1515f6d8efdada83665f69d882bea84d56d4554eaca87bcb3b863abb90cdbebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710f446acd134bab78e117ee719009cd471a85b805fe353feab47e1f298ec43d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c58581485579201022395eb3b4b9cc73fba56a5c75b5af2329f6d154e9281148"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6063937a23ed1257051372d951ebe5ef9810a39a59b4eb4eb9ede01c32480b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcfaa89967f1eed7c4d9e28f0e8e29260f56b776d764f3a73b26b85645324cf1"
    sha256 cellar: :any_skip_relocation, catalina:       "c7c6e364a6dd582070b01f2c2d5294ac1ac4df24bb63ec6f762f1e2665ff87cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c56f70197124e2c1aec3cc3fa83599753fed0e8a54852dd4aafffcb87d9e26b"
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
