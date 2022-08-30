class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "49f7cb00b441895c31e5244c225f3cb233c5d6287a9dd2a3ae6e45a347946414"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a614903da0ae9bece6fe3ef323326695d4706be5158aa4eea0e4df198fffd47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af52a07dc20c462f6206fb0bf98f0fe1223a0467b851d40e451805f56e98db37"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8dfa4777859c7194bd91448184cd46c51557348866d25d54062a642dca869b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57a05f2adc0b8369ced111f6331f581b4865043a1b11778e98b7891bf5bb8c9b"
    sha256 cellar: :any_skip_relocation, catalina:       "656d090f4b71c1418c7fc53b88ff79141abcfb1c7e0c66aea1236bb57555e2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f17e65ab1b992bf0badc53c34c858189d81d0d389d0e3dec8ff643b7dbda263"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
