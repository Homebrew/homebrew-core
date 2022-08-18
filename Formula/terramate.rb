class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "150f7a64c629506b4288284a436096a8c4854bc0c2de674aa2463807284847da"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd8855a8275298a3dc675bacc21b9b9d36c1c62ccdc02c574008192f2c9959c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba2204c47097ecf051e62ed33c6d731b3c032a80221ca8487290109792456198"
    sha256 cellar: :any_skip_relocation, monterey:       "b6bb48e7e8db4f2dbd6b80b96a63bd790874263791a0d17801a5b7a9d78ae011"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3d3b8f7fac41e33d6420b1ec0fa85d553e3dc23903e648c2a11a7190ff1ef1d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1df9bb82467e8aae7636a0b5e7821ce5afadd3ae9bc488ca4e597334c009162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100ca060ca3ae91378ee2a9e973f1055f5517d2c562b086fdf55631479ac88cc"
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
