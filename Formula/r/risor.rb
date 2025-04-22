class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cb74fffafee3491ddde6c9265ec3198131417fa9c990c2647e1f86dc281ea4fa"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8e1292de24b4e902fa8180857c2171177f820ac40388a5e6f5fc2f1a1f3bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45bfc6da12cad84f948fe980d92b12d44cc2b0e1fbd7f8132a179d586ab846e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bd4dfad3c4c080d9d3c62df315115adb15ea6953285efb2bce2ec7c03344691"
    sha256 cellar: :any_skip_relocation, sonoma:        "7888be33dc5ade02305f3857fd0a176ba3f96ca69a1e06b69055afa6a5b9ae82"
    sha256 cellar: :any_skip_relocation, ventura:       "967d7fa03a9aa306efde26606200aef642624d29c5c7456f6f432be9ec30ec7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b7800c2334da4b0f85d34780993289615bf1f69ce1f731eb32f2712ae0f11b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fbd777f72cc1b135297b1b59b7ce0aa180c1cb2042b86b4a7a7039e5c1ef04"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
