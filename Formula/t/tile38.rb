class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.2",
      revision: "1f5b487635218cbabf9a8d35faba9f1b3b0ae45b"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bcaaa468ef8a7f5ae0937c2b98edc2ef678ff19f3e102a8da833b2404f61ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44713b379e48a485b7480b27101a0fddf8fc8b3830ff89b1287f8ce6c0292fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe2fc5ff246e6dd16d46f29fcfa734cdf0cb6cd2cd660bc62f47ecf03696cb76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32be4651108ffc1dfd90acafad99d856729b90e45200fa87e494798b6052c7e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f48916402beae7da2c985e4a988793736ffd51d8ccd8b8c3d64caacfa7fbfa"
    sha256 cellar: :any_skip_relocation, ventura:       "05acc287151dbc7140f023e0910e4fafa26b33bb82538751e32eb3010672dfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1c9d47b301c045dea7769da3bb9609508746ca905ebafd0d299c489245bd97"
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
