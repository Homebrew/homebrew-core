class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.61.tar.gz"
  sha256 "950bf69bbf637fb7fdd40d6ba9a95b0925a7eb11b030e0ccb27fba6c688711db"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9337f4dfbb2e171a95400b85eb0d866812515d228c9ff0d7e59c70d131263674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d79bf1b1fdfd3c252be5eaa958467e523a95b46bfb59d319362337b324eac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91e0696792dbdbdaee5e7904bc8a08fdcefd7eff2e466078f2f9c2b946754a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49c50033e6e701ffa18c72b1a5ea8f53882f257a63133a1e615454cde3d53dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b466f1f1b67e5ba5cecad0e4870f5fdaaa01a55d8a537c0c54fe51fd18c045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4973e0e1b8ceec339e2242a27bef5774caae9e9003486cdc546034bf5ef1a41c"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
