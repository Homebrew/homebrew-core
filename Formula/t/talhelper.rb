class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.17.tar.gz"
  sha256 "795b8aeb469a8e1754e1ab2ca60b1f62aac64d3f0c2204967dda76c37c82aca0"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38173cc08e2259432e42a0fbfc0838291ac13c5af6cf7eb8f1cc99cfa2060731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38173cc08e2259432e42a0fbfc0838291ac13c5af6cf7eb8f1cc99cfa2060731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38173cc08e2259432e42a0fbfc0838291ac13c5af6cf7eb8f1cc99cfa2060731"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf96285adec6c422739efa2340351f6433cce9488b4869c008a939050acb5896"
    sha256 cellar: :any_skip_relocation, ventura:       "cf96285adec6c422739efa2340351f6433cce9488b4869c008a939050acb5896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed8830be60ba32c9974790f6dd8ed19a0906f3ad749f88dfb28c1207a375a53"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
