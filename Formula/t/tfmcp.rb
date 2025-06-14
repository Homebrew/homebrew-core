class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a89882037b1c0a85d900b9e5d34edbc3c4ca78c648e7e54f423663c286f769cd"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1d37d1f0afc8606af8d61b58ce87562353684d98ed17d6e95d5056092a448d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec63fab7c65d3f7336871a3b73197638677766164670f553a6aa76f173f4f9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bd00155426fbe42e66b0407d99cf051e92a748c18170fc42af5353dd4f9565b"
    sha256 cellar: :any_skip_relocation, sonoma:        "362715e0769e7a47ba53e588141435f145a3463aa68033276f7ed104588d8634"
    sha256 cellar: :any_skip_relocation, ventura:       "231f29d10d19a1af5e6fa244d4867472a0e8e1d28eb32604ee1206e94642dad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575a05e0b7b7c95fee7fedde98338e4dc02701b9d12df6e644e928c1c336dd2b"
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
