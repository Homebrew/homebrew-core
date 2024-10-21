class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.3.tar.gz"
  sha256 "cdddd6d0ec47a80ea28fc7eb411e1723e355e08ffad0369436d9f192d96382d0"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304dd4a56843b5b49a95a670c0e00f07d3b22acace8c7e330b915416f6a42f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f83e54ce024d8405f6c6d8f9523db92d3606270ff4796759fe0d35bf121878"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a96530c09fd92185ce00feeb1089fd7a43fa22f9f1709e5dc95b132ea336b403"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe89f765057f30a44e94b8884f8fabeeda474e5a6bbc4dc6f7a5e133aacbafc"
    sha256 cellar: :any_skip_relocation, ventura:       "d4dd6e71b39d8416c372f2da33b1d1a329b56abce337db6360dbabacd645e1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "affffc04ea97de3578ecee3aeaac4a18e94dea2f7944883cbdc5da3732712a36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
