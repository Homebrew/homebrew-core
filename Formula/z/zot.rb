class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.47.tar.gz"
  sha256 "25eccdd2fd45b160f90e7028ba769c520345e3ac649b66046833fc8740042c29"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4e6d33b44639aa92da027d8ec1d5add6ab639e2e12995de74559a8ae1a6c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4e6d33b44639aa92da027d8ec1d5add6ab639e2e12995de74559a8ae1a6c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed4e6d33b44639aa92da027d8ec1d5add6ab639e2e12995de74559a8ae1a6c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98f11958aca4dcce08ea587e7d036a7d0a32db6eadc8d8b0ff53d57f51f59c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d48ca37e2b69a057ddb682a862178b5693295108f2d151bf6a664d12f6b5a53"
    sha256 cellar: :any,                 x86_64_linux:  "8eb23fb15ef789718f43a2272c8d892530e8f1df0f354e9f62a1866893c0614f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
