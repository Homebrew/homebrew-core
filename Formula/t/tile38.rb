class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.38.0",
      revision: "e6e0c39b5e7be578cc1aafd17751fe81c286e8b1"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab9340b0061466cded5e6a59bd83c5c9b6e1ebf0d4110c9d9ff2e79213705fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e6f5cb09bff68ecf2fc9b31b169d432fa42b76cfa19fc6d9e573bbd700e509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da8e6f64c785f3ff658e7904d8bd0fa46bb360983041b6c372a7a5c2874aeb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "257834a0dae409f315295184b478349753f44102ad0d81a718c9a82c5a45eb78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f25fbd6d0918c8c4bda3bb4403b9077a7c1f3819e63dc9d32b947b433550d63"
    sha256 cellar: :any,                 x86_64_linux:  "455b749aecd165a8b62baa24674125f6ec3e389fa2effd3b058ad633339714ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-server"), "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-cli"), "./cmd/tile38-cli"

    # Make sure the data directory exists
    (var/"tile38/data").mkpath
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
    pid = spawn bin/"tile38-server", "-q", "-p", port.to_s
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
