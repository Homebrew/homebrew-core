class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.8",
      revision: "79330fb515b72d616e4e85bab98e7401c945704f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c4cdef8926f01186abc7fa3a74377facc858618cde9b871101feb128718e542"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "453082431ded9a17c030b029e3ef7599495deac08f2aaa32e2494440f2ee7db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44101b49cba5a2d1e4fdb2cc4f6b543c11ad2070f4aa1446880d4ec99bab452c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b6a3ea4729d2b7b4c7318ebdd3f49948d644b690c0bf7b517be56dcaa54961e"
    sha256 cellar: :any,                 x86_64_linux:      "37163a3568d936b675173a9256e4a9d9c585126d3955a0b13661d3261b4106d0"
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
