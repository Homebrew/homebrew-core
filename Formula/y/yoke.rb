class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.5",
      revision: "6d06638e669db834202bbd12ee3f2a5af1ca8774"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8952a7326e3a9dcfc4ab543aa023cf3480807de3bd77bf21f4659142b9dcb9a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e06e666fd800fa096fe8c5a6392e786f28607fb89752357886d1484f0da9077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87032df66f92f86fe0d28623dac683d0329009c5f01efa5a144b7641b81024b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a97f2fddc0e975e7168c88e9f6665aecfba58eb89c1e840d6f04610b55545362"
    sha256 cellar: :any,                 x86_64_linux:      "6c3001d0d9a7b82553e3f738bcbb76b9752cd5a6d77e5369a5c2836fbd9c84c9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
