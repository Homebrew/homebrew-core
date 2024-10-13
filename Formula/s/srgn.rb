class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.2.tar.gz"
  sha256 "cf7fea4756104cd9d955feb4dc07f62f2636e1b23a287394eb55116d2ea5dbd0"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c682d3f95bf9b1cfa87e3c31593b458b4ab5721f94197dcbffc7b613e3de0b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6e7afeaeb48ad63419c7e46f0d21ac243cdf8f2dc8f9318ee029d2a8d36927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09e34437888947b146d175aec0b2f17efe6a8bceaeff990d9b9528ab15f8a785"
    sha256 cellar: :any_skip_relocation, sonoma:        "72102cc57ddd466d8ad7bafca0c6c91afdae10e6988c05815e42d11526a8ece6"
    sha256 cellar: :any_skip_relocation, ventura:       "218bf094d83593e05a38216cd255d5ad9a6b79fc0e6175ca333eabaa2a2d7f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd8955c85ff0afcd3da960803a7a7d01f3c29036a4f17eaad5b4e93d05fdf9a"
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
