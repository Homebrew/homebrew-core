class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.34.2",
      revision: "e40a665f65a5acc09fa8eee110f244616d7894ee"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6adf3f90a703deb17b2ed31d2fe7fb92446486ffb426063bd56dddca98919d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6adf3f90a703deb17b2ed31d2fe7fb92446486ffb426063bd56dddca98919d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc6adf3f90a703deb17b2ed31d2fe7fb92446486ffb426063bd56dddca98919d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5869cc5a03fde9d1cc89980fa2d8094e287d59f3bd931344286c31cf7fbf5b6a"
    sha256 cellar: :any_skip_relocation, ventura:       "5869cc5a03fde9d1cc89980fa2d8094e287d59f3bd931344286c31cf7fbf5b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c19f54179b1957cd3836df778312aaf9c93ed4a90a9c45fa8a0bda4b6892f0"
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
