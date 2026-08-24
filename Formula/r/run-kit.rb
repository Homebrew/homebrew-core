class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fcb22f803107cc7a7a5a3bcafc37e12e150d50ea6b41837577a750779774c1a2"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f936d6f310efb6d43fafca5add1290feec8a64c8122488ca168f50f132be826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab69979940dd0caec1d2702cdd2e779874bd0fc3b969b99bef899f041a932a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3483aa15c73e064f94b995d5eb52f3b2a8634410f9a2c47e0e9f7e55eaaa90"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a895bb34a5257c2f68cc2def3ed72fa0114339107f1abbcb8cf0c92407d2fbc"
    sha256 cellar: :any,                 arm64_linux:   "51919d61c7b14426223160b1d2b2995c76484e9177aeeb7dd29c84cd5b629d4b"
    sha256 cellar: :any,                 x86_64_linux:  "bc10658e3a0da33cdf9705aedf5b19d22c33d92037ba17711ecf24f9f374b40a"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
