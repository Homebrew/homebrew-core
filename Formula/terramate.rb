class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "0c5d5deef8238f08e7386b46a0917a2ca9634629a2d9b378955216bb0b81cb86"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de9a5cb2c4264b00c51898df55ea00461d9e640a7985e93c3c96df1bcda7daf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5ebc37b3573aa0b413e64eb98b2e4b95032a2a8ecb2c643e71e9c0992111fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "990754d775c6a06068fdb2e6de50b69f9e48de1d8ea4345cd80b11619fc8ff1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "53120b818cb5f8ad921139a5b970e68d034bf416a7caaf66f1b7d50b8795020e"
    sha256 cellar: :any_skip_relocation, catalina:       "2f1cd274e7fbd1a0631b288ab37f337dfa99864922c6867ef797c1dd47d5c740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ae72e79cc1486772576ff2fda7833e2f130dce31ccf9db01e59c3f0aa2e7f3c"
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
