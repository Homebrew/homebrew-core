class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "de8d140cad1d5d00114712d2cb8325a1f3a8a8dac94f0e0d25c590bfb486639e"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e719ca2e07fe822fe369f7c29d1a9c24bb22db51f1a2117e415e7acd203ee3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677b1c7428e696e7fda2b42adc3b25c5324ff0260db256f0e45249407b4eaec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9ba82386458b23a469c2a44f63d0082f29a70e0b4fae6e2f1639d5ea70a4c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "46da682adf6735fdadae113fc41d653e5c9ea7a8166baea4f3cc1488454b430f"
    sha256 cellar: :any_skip_relocation, ventura:       "7a88eab63c27dffe542c17e399c31f3e66c4b094fe84d2e30c0aa9b642fee91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09cfa3f948a2085274aa67e048987c2696ecc609aabbf8092e13c304474ceaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc4b42f55268b9805ae1f337db8491a91f7ac456cd27b07f3320ecd427355801"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
