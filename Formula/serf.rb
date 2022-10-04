class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.10.1",
      revision: "e853b565da00a84dadd5e2ea0dc7919250ddb726"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072bf0a61633a6ee92d9c80fa26caa80bc7347f8a05bc1375f69c2988f7b75e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44572bc73830df57ff5888e4e87312ee4cd193a2c593d4daaf8f9d628560f676"
    sha256 cellar: :any_skip_relocation, monterey:       "e440b4ee34d49a1218451f3386d82de12b200b0f91926624bf34ad7e58ccac54"
    sha256 cellar: :any_skip_relocation, big_sur:        "76d6f3326f99e239d3fec8d3becbe08ad21ca51dfb52bdd6cca04ade960edfa6"
    sha256 cellar: :any_skip_relocation, catalina:       "384e75b881441902f6d7e0b96f72f547a7de6cb9dda0ef6f606ae241110418ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc701296a0e70345a64c7e3d5b15edb99572e60ab461395dafd5f9fb1aad2e2"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/serf"
  end

  test do
    pid = fork do
      exec "#{bin}/serf", "agent"
    end
    sleep 1
    assert_match(/:7946.*alive$/, shell_output("#{bin}/serf members"))
  ensure
    system "#{bin}/serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
