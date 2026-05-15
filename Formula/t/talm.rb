class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "a22212b0bee7928dc562b65d0f5b06e82b89a850ba6c3c748da0bfef5583dcbf"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aca5dbdae648269c1d890530af8b212616b2528c3034eaf76e5803ba923ea1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1fb186e1945f538ffcb56608b1d069ddc164a9087e8958b7001804d9dcff36f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6640c345d16b8a0232bfc58cbb927152e1703792ba061fd0eb6317ccf2eb3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10483d1d09b4e797f34cbf657b6c0fa6477eb8aefcbc63a9c3e514d48140f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65388444697331db11094993d595a384238ef9027846f9b0430c98975263fa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1351915a6e4e768c7638e6b359482e19da146f1bef37e242e38ddd7c38836c1f"
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
