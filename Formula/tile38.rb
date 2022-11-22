class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.30.0",
      revision: "a09ff07c91f092febbe1e06c87108f6c670d07df"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80af85c83c7812e6b80a9938ff1f17181987b14b1cd2511ec3135515607bb49e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af90e348b644c1a37df16d3e67e77e7959586be1c85fa6a0d0abdcd7968d919e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a1c5e6d179b96f6ec5fa74bbaea8a04e2db5ef1a59a0483a6f5ee1aabba0647"
    sha256 cellar: :any_skip_relocation, monterey:       "6f90263c54a4981ced7b8a668760345eec0922ad03fcdcbb0ba40da782e5d9b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c1bc7a09e56c1d66d763ecefdd1f554d6a688386e8fca479dc8e3e3baa006e"
    sha256 cellar: :any_skip_relocation, catalina:       "28a9b34ac641604271ccd5f7097f6ceed80f526736f903f51a2c7ac294f36764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe771ccf23959c92b7bff8d567ee885deb6be60b2d4bdb1b99894db7879e4a9"
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
