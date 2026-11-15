class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.79.tar.gz"
  sha256 "c97877c1c51bf887003b3b3fc8794dba4a78b5dd09d08fafbe09f152a4fb34fa"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d22f864b28b580f2b174a7bb4593d1f909c59b7e2f0fe534c5699b5730dd4737"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d22f864b28b580f2b174a7bb4593d1f909c59b7e2f0fe534c5699b5730dd4737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d22f864b28b580f2b174a7bb4593d1f909c59b7e2f0fe534c5699b5730dd4737"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b618b71dcce4a0693f8bd173c849dac673cb4b7a4a668ecd52b694adb065973"
    sha256 cellar: :any,                 x86_64_linux:      "708dd25674e19a58bc4f1256932b56970053fbf0f6e2a7ae6565dae02368e125"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
