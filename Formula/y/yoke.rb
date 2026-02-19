class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.3",
      revision: "5b0b0bc87294f293226f219a67d57268c06edbc4"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43ce8a6555c7e89cf59199659c826304ed00f0e0c52fdbbe9c7477c83e71a5b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f456f7c2b2c42480a3d421ee59ec2d15a1428f95a5e77c5a0c379ab1da3d47a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f71f9a2d92d515c3a01ca00ef8a4089b4619b74cc3910e3b62c2cb7398e54c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4e69f7f7829c1c274945cf1a04d1d0af76e16351054bb4ce9820604a4360c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c3f5987b6733cfda9df08fcb91ef2bb48acfde6bae54df17199160888f6ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36b0c20721c92b99010fdb4f741785f242888aedafe43fba424711bc6116216"
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
