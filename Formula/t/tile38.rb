class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.33.3",
      revision: "a3b5db776fdcdfa503cd2e22b4daa0f8a8e1440a"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc34844d55aaf73b4994a1c7abf922e055448f31746760591bd72b547e875de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc34844d55aaf73b4994a1c7abf922e055448f31746760591bd72b547e875de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddc34844d55aaf73b4994a1c7abf922e055448f31746760591bd72b547e875de"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f8a59df70928a9f629d44751790e993e768c5b3383a76247241b8f4b95e980"
    sha256 cellar: :any_skip_relocation, ventura:       "45f8a59df70928a9f629d44751790e993e768c5b3383a76247241b8f4b95e980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731efcfbf0573cc299d717af58fa82f6e3c6b9b780c043f99c23cc41c53c371f"
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
