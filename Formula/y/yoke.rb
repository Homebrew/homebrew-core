class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.6",
      revision: "c8fd6e574e3558df944f78cb164ab9cd61812fa4"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f420adc28eefa913b7baf220c6508dc695848618e9e0613682910474718bc4dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71f70f88d5cda51c9c28a838b9273a12d38fd5da1e4dccaa34c486fdc25490da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "383d125581883e635f3197c547deeb93b4e84607b58e97851c77a901301e261b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a5e768d1e4126b9fe0298ae50ac26315eb1c90666f660bd9cabcb678249ca01"
    sha256 cellar: :any,                 x86_64_linux:      "ef2d592e2974a403bb15e8cc01ac9db5167fe284f0fcdac8bd7ab34a4cc3806b"
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
