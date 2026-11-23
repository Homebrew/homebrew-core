class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.23.0",
      revision: "e9f44ed04ebaf1c83383ec543508126b78c448bf"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    manifest_sha256 "95544ac5a2d537bded81bbb20c7126cbb1217c49e52baabdad52423c6d673112"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7583143b4342fad05e32dc3d3c999f5b0a61735fee0f90f3ad915057f850eb60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "452a26b6df1ff28113b3cf685be12958198b1eb3b61eda43803c42e12d80a32c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a1f2750f0d3e4e6eb33cc8b22170088eae60002818985c7431a9fb23ff48216"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63b3453076e401a608db5d2254cfb693cc496788ba27b9c787bac8d189abeb25"
    sha256 cellar: :any,                 x86_64_linux:      "9c28769e098fbfe0ce5d2206033d25a0c7046de7dae653c301d6761a7d85a37d"
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
