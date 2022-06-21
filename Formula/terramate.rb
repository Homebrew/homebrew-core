class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "acb0f7fae28ce35984af51119674fbeeb44235ce9605ab9d1381bb425d8edf0b"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f69926d9b79f1b97c1975f78affd4f8484d75abf57260ccfb4b78ba42932be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42c159ebe0ad8ef13b17dce1b2e733f2e43b312f355fca6ad5d3023bbca18c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3d2fb623b9f46e78ee49b37076a1b7aaaeed83b8c1939fd5db469f0f8fce33"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e7ea03b018fae059274056e0be6568778e9fcc9f909ad94cad9c66d05d10ee0"
    sha256 cellar: :any_skip_relocation, catalina:       "0e73a0506381c1877d77c333eea9d2850c7a66695592a9780390c7738a6fca9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72474acb5825446d3fe8c5812bf3aac8152bf22e282188005486a9437be6b37d"
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
