class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
      tag:      "v0.17.0",
      revision: "dc942da234caf016a69df599d0bb455c0716f5b6"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ff141e91b71942f67871741dabcd110310a06c72d68ce361391e2a1ce233ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17af62bc7751903d4f85e447907825f3bf4df255263487c47b44e299a9b196be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767212e3c8d9dc59a030aa96083a48f42be86fa4c43b1df2158c6d3d9fa50f54"
    sha256 cellar: :any_skip_relocation, ventura:        "ca9b4d2758cdb30d4d68573285228d3ee30f007b0a10f2b1981fca2b5f3ed300"
    sha256 cellar: :any_skip_relocation, monterey:       "6e82da7f0cd74193592f16415ba7386c7483bf9006814177df8086cc96e7b57a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2955ce82d16c3601d928d8f7125bda27dde894fd9e8b8c8e2025a178c38cb640"
    sha256 cellar: :any_skip_relocation, catalina:       "6f8469a79e442788d8a8c774c7097ee45d1deeebb17968c79e4efbd37965e69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ca55abf39725e1760d6610e38ea05f089fd382724da55c170f2cf914ee1050"
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "libpq"

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolonctl", "./cmd/stolonctl"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-keeper", "./cmd/keeper"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-sentinel", "./cmd/sentinel"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-proxy", "./cmd/proxy"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "consul", "agent", "-dev"
    end
    sleep 2

    assert_match "stolonctl version #{version}",
      shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>",
      shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version #{version}",
      shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version #{version}",
      shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version #{version}",
      shell_output("#{bin}/stolon-proxy --version 2>&1")

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
