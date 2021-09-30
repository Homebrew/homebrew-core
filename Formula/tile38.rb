class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.26.0",
      revision: "26f9678ba058fc3ff325244a21928fa6faf64bee"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5f5507a33b292867d42143e9b4f0706a3fde9187f90045f52f2a3a7576963c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b6eaf0d7879dfabdacb3509b91e8689cd554547ad2f877c3bdc0bba9c3d54c9"
    sha256 cellar: :any_skip_relocation, catalina:      "39f943f53c29607847d953aa357281bfa60a3d1f5b1bc84daaa962f9196707bf"
    sha256 cellar: :any_skip_relocation, mojave:        "49e1ff1ddd7156a25a6ce4fcf3d4091111be0450eda8e7aa5037a8d05747e3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17940d8891689c2f9a2ecb7799157c0c2c65a6596eceb9a05014a59569d82565"
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
