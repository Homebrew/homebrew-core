class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f8a85c7bcf8393c15da73fa62e01e9153ddc196bde88f2cc31e293411175d81d"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "394bf5c1bf1e89bc542aa8d23576a99155ce6aeef5e2cdde713b21ef2891eb53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41bf3522307f317b68f38ec9ed60f96c141d7ef5d006ca1e1fbe321ca40543da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ca847e953220c0b5aba409d34f77325103b9384c33816de83484faccc4c5601"
    sha256 cellar: :any_skip_relocation, ventura:        "b1f93cfaf3714c220175500ec28c09ad829547aaeabdf5043164d1530e2bcb8f"
    sha256 cellar: :any_skip_relocation, monterey:       "916f13cd0a7dd6613c301d9bce9bc21139644d6afa1d35875ef8e07d60345fe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b091ef13996c964a67228427062a5fc5ee58ed5330e01e0a369d6be5f8aaf7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883ca8b8847a9f0047df8ac1815cc4b40a52889e12006914e5afa1fe4bbc46a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "Project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
