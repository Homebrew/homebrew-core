class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.56.tar.gz"
  sha256 "97f9847217dc1a9eb4e0ca7b77f22016fecaaa955e20c32a55e4e9fff76ebbc8"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f1a81d332efef5b64f3ff26ebe10f0648ce3760b64cf7a54185a51136e467a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f6d2c6b1812044eb46f7bf5e1070b4e92525cc25699090aac8d60456544d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0418f035e57cbd474503bd5615f902ef2ab351212ac9a275a8a255a2a5459fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a599511f7bb3ba2c1e12b5d057c1800f9f0ae4cd714b650075522b53dec31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e40596f48ae7bb04770d082b7ea88025292c133c425e7b20b7660c933f9721"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
