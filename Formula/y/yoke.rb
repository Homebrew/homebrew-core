class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.12",
      revision: "5aa8d080df82936736db996ad796aded29adfc16"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "095281abf6d3dadebabad5ff15d7203470c102b3a0b64c5ade2f44c84eeeed63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bee0e074c4c731d5c93636ca9d89fab3822f95d249146f0aa9d725f9e023754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4571374cf111ec9739c26e090829ac756378aa37d1c045e20303173c0b752d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "4311d519316e734cfb08f1f346bb0cc94c41d17f1c4e7de7c6c9bcc7afdda06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e4bd624074aee6aaa3b4ac4c966c97e9cb17ef73316d4101f29b1dbe6bf00d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "665471b80de0f80effa5966c81eec43d27fd152b336a6f9944693148e7857687"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
