class Tfocus < Formula
  desc "Tool for selecting and executing terraform plan/apply on specific resources"
  homepage "https://github.com/nwiizo/tfocus"
  url "https://github.com/nwiizo/tfocus/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "cf8d841d170c551e8f669e8fe71b5c85f0f2b36623ca6e2b8189aa041e76b75d"
  license "MIT"
  head "https://github.com/nwiizo/tfocus.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "258361e1ca78414d867f992032a024b6391dfc49737fbf25e184a3b6b6274cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5dbfaf820e34ef9e6bb04d45a1d277fea9a27cda78fed88ae90f3686efa0006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c72c12d7d0620fe84de30e04a49bdd1c98961891ec81267b95957c3dbc5dfbeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae42614fc40aafade49f9d100c5062396a5ae898c69967234a0762103fa550bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b997ef677047ba1e07f50d7bef51846e68c022fc7dfb73fcf1a6abc1f674654"
    sha256 cellar: :any_skip_relocation, ventura:       "fedfc7f38e939c9774d87f0a0323dbc998a4ff996d9bf871ac59c9c00e52050b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773b63ffe352855a4c69c081dfa3286c894f02c352108f66bb2a7635fbc62542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fac1961de78a056730c0b3a0695287a27eb52bed318bd05bb5606b105a0ac1c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfocus --version")

    output = shell_output("#{bin}/tfocus 2>&1", 1)
    assert_match "No Terraform files found in the current directory", output
  end
end
