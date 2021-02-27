class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.11.0.tar.gz"
  sha256 "942148e22ef18644815681f4a0b61c43cb67f88f4194a93d3b80ef9cd3116f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ee8314c83b133a3449bba2e7b308070618761811f2db0744cd0c43fa0a84fbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0b131b1c6e011683f390d88b98b8eab55cdafd37813b4555ee45bafdf2f4d92"
    sha256 cellar: :any_skip_relocation, catalina:      "ec3824a28cef0dd591b4d9f7361fb25e4889957cc71952914e525b9f64979437"
    sha256 cellar: :any_skip_relocation, mojave:        "298503956d1b49cbf453430e2341f9afdb9151bb611b39f6863cb4bb80f03601"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.vshVersion=v#{version}"
  end

  test do
    version_output = shell_output("#{bin}/vsh --version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
