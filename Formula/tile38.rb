class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.26.4",
      revision: "f7980eaa3f2e1f3024d7d17c7c1c16f8a977c00b"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafe973e532fb1bff31914de94ed01c385028aef564f00cf9f86129da30a910f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "286538bcce0ce8fcc41120a3bcc945d44aac13c58e997e0dfe650db97889c14b"
    sha256 cellar: :any_skip_relocation, monterey:       "d89cbd7c487486daa2a7dab89e0e7c687ea82c1f37b34196e29d8876c177bcf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e176bbffe3d06c909d3259a25c2c184987e0f9d3b80e860df341ab6f9c74520a"
    sha256 cellar: :any_skip_relocation, catalina:       "f0b427df3a46e118f78de35a56a7e8baa97b9f20cb324da79d61f5d1309cd5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a994ccbfa467bef9c94b93e70366629d642921d6c903892e32077bf6109563"
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
