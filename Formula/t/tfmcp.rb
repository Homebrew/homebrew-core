class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a89882037b1c0a85d900b9e5d34edbc3c4ca78c648e7e54f423663c286f769cd"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931642d7a76e3b6941c38a5691a96ded7ab51a889a0fa03955a384a9a4f1a953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b738136715521cffb5aa68fae65d696f32a2f36a46372103961faa995a16aa70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42aa5bfef250c2bc3e94e2aac5bce1df8a0f85f74f9443fad21f53be2546a2ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "80277c181cb63ff113891a872df6a621eb48fb301625ccd24862f1a786bd9be1"
    sha256 cellar: :any_skip_relocation, ventura:       "ae4bf79299b8a6b074a5d45bd0901134b0d0b4595e1229c2ac48ce58cc668960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208ec88b705eb8d5515ed9076f0c5f2c67a8411ff7decb49c16f062a2f616e41"
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
