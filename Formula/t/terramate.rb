class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8c00aa211834975851590cdf57c3974c504239303bfb787c2baeecdecc12b7e0"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b5e8a83092021ab5e699efece76521bacfdb55cf3911ede45d78d34e9956308"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0500fe0dac326557613267a7c876adc6816c81876770053ac9c5a3f493627f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5be02af711b07dfbec71427fe3dd4b687a584c3723bb1f51a3489c706359528"
    sha256 cellar: :any_skip_relocation, sonoma:         "af9a6c0b831e51c4ab5eed140687f23b257ddfb298d300c1746bd70720d470eb"
    sha256 cellar: :any_skip_relocation, ventura:        "2aca62911ca44707dbc0ebf2a99830f984d04f3121433d998ebcc9cccbef33dd"
    sha256 cellar: :any_skip_relocation, monterey:       "1d4e295841024795c57446fb2e0f8d19b0031bd201d02dd7bed50ef9be7915af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc095358e7ad6345a7e26fa803f1fbbe721cc48b921cea2f269ec994c02f5131"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
