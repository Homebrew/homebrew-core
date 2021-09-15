class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.4",
      revision: "b3c036ac688e7c4743958fe7fa868a50fba4f35b"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9017753d1e2ed6dbe4e384eca75a6e0c8acaf880d075ad050cba3a393ed5ca04"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5f475c5c5c28d32cd809ea2925aabf6f4762f38908e20f7fdf0b68d092eb6e8"
    sha256 cellar: :any_skip_relocation, catalina:      "178e2b20aefbd71758b678687fb564033945cc2a87169a9d8cfdc310b4890887"
    sha256 cellar: :any_skip_relocation, mojave:        "e05a12dcdc1336b8c2340aacce33e7e80e15282fced33b7eedd877a889f31054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9de1f64857229e701dc51a56a2ed6fc7287c1b37fa57cdc610074ae61fed11"
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
