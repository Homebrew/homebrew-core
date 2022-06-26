class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
      tag:      "v0.17.0",
      revision: "dc942da234caf016a69df599d0bb455c0716f5b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da91318804a2a44ef42d195448013fe9696c5d8a6634d28f48c42d12af20e27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4094f00039a0b1684471e1c4e5cb4758e3e7789577dd7d5f00cb3b532a1ef6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef48e603eb0ea38a2b67ae20b6bcb3553e1f208db93b60f2a16b39d63f6d6f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0a56f3249029127bbee0714cabddf2aa1bd6fd8f8ddfa3d930318be36914c06"
    sha256 cellar: :any_skip_relocation, catalina:       "ced3403c83e7d19c21117acb58056756538c9c76dd76c8cf28330c0c4c261ee9"
    sha256 cellar: :any_skip_relocation, mojave:         "544b80f00ebb9447d95a1cb981147b95dbbe668abb0cf6037e5307460602d563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b19327fb4e9f472bd1c830a8c4f33a121a1c0a589f59a64dd6b322cabf87b2"
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "postgresql"

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
