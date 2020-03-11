class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
    :tag      => "v0.16.0",
    :revision => "920fe4b83c158a6fe496dd6427a3715b84c0b4e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cfeccb9b2cc1387e19a41bc6f9888fec1c5c8fc6bf13a0d4b2b49d4befb029a" => :catalina
    sha256 "f513c9ae627ca6d085cbe1e2cd4c69703a63b3f2c8e444dbe33945b8d27140e4" => :mojave
    sha256 "129c66c2ada6dd97ece169a06f1a018ff5c0205df86f83f2edf1dc775e5093c1" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "postgresql"

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolonctl", "./cmd/stolonctl"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-keeper", "./cmd/keeper"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-sentinel", "./cmd/sentinel"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-proxy", "./cmd/proxy"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "consul", "agent", "-dev"
    end
    sleep 2

    assert_match "stolonctl version #{version}", shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>", shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version #{version}", shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version #{version}", shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version #{version}", shell_output("#{bin}/stolon-proxy --version 2>&1")

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
