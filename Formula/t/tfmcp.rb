class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e6ef00157370981ec2fc1447c83f6b47dd10884c4852332a1b090cdda78c9449"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d252aa93ec4e8e2d48aca0c0ffa390e2ab212f23d1c85328efcf3a3b5024239c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d6a1003826c083220ea9eb6cbded664d5a0360010fc0c485ac1b4625fd8551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed1394be14b3c9e55b26133aa88bae0eab1e7790474f7451e531f1b46c79d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d195c362ffe0046e7684bb21984917b3c94e4e656425ba50584708746919a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091a1d8963330f550d5aade99ae3948118b20ab2b51cba8fb5244309766d5e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7857a7bd7203bfee5318277d2450673158d29995914f682604700ae74c5b1e9"
  end

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmcp --version")

    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    output = shell_output("#{bin}/tfmcp analyze 2>&1")
    assert_match "Terraform analysis complete", output
    assert_match "Hello from tfmcp!", (testpath/"main.tf").read
  end
end
