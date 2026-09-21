class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.14.1.tar.gz"
  sha256 "ec4bdb88ab6c95686be3a4eeb4ad77d2b49d33d2ed7b0a65035cd52d2d87c443"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0fc52046a6269af6f1e1a110a491b43ac3d8098e6cdf5bf920984df729d33b1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fc52046a6269af6f1e1a110a491b43ac3d8098e6cdf5bf920984df729d33b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fc52046a6269af6f1e1a110a491b43ac3d8098e6cdf5bf920984df729d33b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0fc52046a6269af6f1e1a110a491b43ac3d8098e6cdf5bf920984df729d33b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "054e07cd5e52df175148ba192d3e14aeccf9cbb9347fc85f5f2138ce899b1a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a3c24265326c8e54873874c733db221fbe780f9e84b964f5f2f90768cc6c2490"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    inreplace "cmd/shfmt/main.go", "version = mod.Version", "version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-extldflags=-static"), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
