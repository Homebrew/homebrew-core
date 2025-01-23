class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.34.1",
      revision: "2e2bd145cef4016e305ecf652915b83211472cf9"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e812fcb4ea3e156c11810b740bdfad4d3ae21f76715090c5508ebaa381ddde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09e812fcb4ea3e156c11810b740bdfad4d3ae21f76715090c5508ebaa381ddde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09e812fcb4ea3e156c11810b740bdfad4d3ae21f76715090c5508ebaa381ddde"
    sha256 cellar: :any_skip_relocation, sonoma:        "09e5501663bd0e11f772c9c1885fc29c6c0fe2e98188cc0e6ca8ecc8d546e1a8"
    sha256 cellar: :any_skip_relocation, ventura:       "09e5501663bd0e11f772c9c1885fc29c6c0fe2e98188cc0e6ca8ecc8d546e1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f78381a888c40ee6e5583420b15abbf6316c88bfea8c5aa789c965e9b7584a"
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
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
