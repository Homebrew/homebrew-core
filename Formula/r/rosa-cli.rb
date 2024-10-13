class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.46.tar.gz"
  sha256 "a425345aec2de5a0a87c8e330e50a8ee77f70fe0ab80b3bba30553b6df50dc7d"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a50bcfb511b185b80d0c77bdef7106c97d03cc57b7eccabc82bded5fb5556bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86034f53f3d29d091d8accfe207947644b759bb1760d64c3c5454780fbac729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c8132ac41d8d5aa3b030e60a3f4b04951bfe20c54a29b75fde5f73f8787cf70"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad868911aa853087392430a75897000a196aa18812da204cfbe1ad39d7054341"
    sha256 cellar: :any_skip_relocation, ventura:       "0cfd667dd80433ec9d0c4cf35c7a7d7c6e89246bb350224fa64d19377c18af83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7e64face915e64b16125db7a962ff6062f5bc4d5304a4b5b4419d69f670322"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
