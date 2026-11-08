class Woxi < Formula
  desc "Interpreter for a subset of the Wolfram Language"
  homepage "https://github.com/ad-si/Woxi"
  url "https://github.com/ad-si/Woxi/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f66f6897873fe8b2cb77864f9bab9cbdeb28195169c0db3e97060eba3f38c57d"
  license "AGPL-3.0-or-later"
  head "https://github.com/ad-si/Woxi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7c6b9dd0082a03feadf3107e7e617ae3c59703fd5ec4b02ac1b6af09992ea3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59c63a311e330c7b7720926ac737873d550372ad008aa113b25a456c52d9a45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98d190efe1ba3597910d02b1d936c0a570714d268c64b8d173d9ad4a54e18505"
    sha256 cellar: :any,                 arm64_linux:       "a687b0d36c72fcaf964ef60544a6f982ad89a467ac078525635c948640a6b228"
    sha256 cellar: :any,                 x86_64_linux:      "c695b8bee9d95873e3b6eca18e19b056fc2247bf0a5566f5196e862959bf358a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "woxi", *std_cargo_args
  end

  test do
    assert_equal "3", shell_output("#{bin}/woxi eval 'Plus[1, 2]'").strip
    assert_match version.to_s, shell_output("#{bin}/woxi --version")
  end
end
