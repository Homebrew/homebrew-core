class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.33.0",
      revision: "32462231c00ce294689cbef5771abee7221692d7"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97a3bd30cb4191f9073c6e92400cd2c9c33686f38df7dae9fdceba0fb41edfe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72b17d848eecba487aa36bec0152298983bd5525ef9e0fd0a32e1b6b8001bc5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a8fabeb9c92bba22218a7a250047385d65fc8c96b27e95d890d59b220f9a4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7f94ad7142be220e99dc14e459669407466e73c00343e9a6093579a071fc26"
    sha256 cellar: :any_skip_relocation, ventura:        "68b6faae42eaf8398d777ee34c6a15621473fc1d385ca372e824398490df1fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "a27e1549a71d97a9e54da08bf68cd9d86739a5ef2ffa4ea364bb51de91219b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d9131b8b0920dc3fde3acc387e6505d6039d0a4aeb6283d0a58860cbbb0f47"
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

    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
