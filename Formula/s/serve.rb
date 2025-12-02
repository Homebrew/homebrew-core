class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7797a24564d95038d9e0a44f0dafd1dacb7853ee94d21bc0587bdfba6faaa6cb"
  license "MIT"
  head "https://github.com/syntaqx/serve.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3b8e2d2b16567d27a72182b7c4238ecffc186c23f78478534d0594f1bc88da94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "341258202fb50eeaf467342669a26e492800683fc5dca43dd91f84c585ef336a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5f617c56cc80d5658b19d32dbc6002f5de4061af0da97a4ec7c2d420b8285a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf7effe016ef9a0cef9f6325983d0071b6f7ab8097b99c6b79c926efd2519a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf7effe016ef9a0cef9f6325983d0071b6f7ab8097b99c6b79c926efd2519a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bf7effe016ef9a0cef9f6325983d0071b6f7ab8097b99c6b79c926efd2519a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d713b0211cbdcb91ff28e1a0cc481e7870a9956f51f63412730c060841e02c5c"
    sha256 cellar: :any_skip_relocation, ventura:        "205cfdc9a632e8c90d415bea94ab53e9a029afffb7d870fac8018bb937e43b98"
    sha256 cellar: :any_skip_relocation, monterey:       "205cfdc9a632e8c90d415bea94ab53e9a029afffb7d870fac8018bb937e43b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "205cfdc9a632e8c90d415bea94ab53e9a029afffb7d870fac8018bb937e43b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "380da6ada7f3ea7498102ad7ffcc2345be1d340bd1434cc3529f7efb264db128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40325f69042fb626e7100fb49097752721fa1cc376bcf3cf2f53f5e49b215efc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/serve"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/serve -port #{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
