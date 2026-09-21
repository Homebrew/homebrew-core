class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.0",
      revision: "99098644d46497c80c1450718cb7865474757442"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "350e64e503db0c1e2baf3dd2f9ca82c2befe9d7cc7b8da054b8c0c21f264229b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68eb0a3ca0ecdca07cde66a3a94b5e9d5d1437b9e6281a1b5642e3d4975a0e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "324c43f7479b308c23d8dd172aa26a00b3f6bf7f789a41d3977a8097d75becde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "78bf39ad15d2cc22bd0b9d99cf655e299ec4b4c8d8fe9f06e0466a332e1b2101"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3348f558bb77a68d557c58eec5b809512271d54b291c245059e988b33b2d5f1"
    sha256 cellar: :any,                 x86_64_linux:      "5f9a5a0108deda3013c52b6f91ca76b0acc051feab01adaa27dc3a937583cbd4"
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
