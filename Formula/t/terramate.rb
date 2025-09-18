class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "3bf030af7821ba762ac1321ffdf8e401928e1f7a9dff15be42abba62410006a6"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "555dde82fc1d7ba8e4fd0bd88f3437786f0dc0af0b26dac6d3e5e1ef49254462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555dde82fc1d7ba8e4fd0bd88f3437786f0dc0af0b26dac6d3e5e1ef49254462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555dde82fc1d7ba8e4fd0bd88f3437786f0dc0af0b26dac6d3e5e1ef49254462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555dde82fc1d7ba8e4fd0bd88f3437786f0dc0af0b26dac6d3e5e1ef49254462"
    sha256 cellar: :any_skip_relocation, sonoma:        "4807ea977b11a591a93c101bb738ba05ba858b3db5437f048b02a84f08500196"
    sha256 cellar: :any_skip_relocation, ventura:       "4807ea977b11a591a93c101bb738ba05ba858b3db5437f048b02a84f08500196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa114fcdcfcc08de86ebc953c19af282a362ab2242c05270e66d86f11bcf7ba"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
