class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "564da69efdf8f1b6e0465c27131d2cca44129fc18ae6762b12e03214ca334441"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdeb5228e591cb8e4ac566a85a67b5a15d5a8f4e329cebf24ca0cadc199a810d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f769da8840d79a13ae64661020c8b91365478159e13013e498f790322d2a2a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfad8df9cddb049ed68e1a484f2c0a4a4b5c25679e0588300c545a13517dc138"
    sha256 cellar: :any_skip_relocation, sonoma:        "6228d729db750531b59ca26b0c45d50c5432501c2466a7ced98d66985e89528b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb566c6c60c101c8969aeb886b82ef07a841f42c6f53b85ef2efae3bd40bc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c5b87537f15d20b51fbacd195a58a510977501b4a36095c4d2d41ab03377f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
