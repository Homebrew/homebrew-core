class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "cdce0a060aa3c30b6fd51a5583c7d7fa228445412696a2a1f7aab835f059f55b"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd146a27268034a253a3ba2ba175657b7532c9fd5565ad28063c6bddcac1d62f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41c5d1392b6f599cbff66cfbbd9bdac2df01f2cfd6938d786ba7c682be17fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54a55314b744842893e65cd05fc8b6866527b7cf017e73c7d51d6bfa166cb81"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c289dc9029cb3696fc40bae99539427661b844d0de8461905a973b57f963c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d94e8641528e0dc53936fcb129d0eab08ffb1d9b8e0438c6ad64ee69ee5808"
    sha256 cellar: :any,                 x86_64_linux:  "233278061fd7993f3782a3d9c941d6d2d9a8fa24b2ab7bbfd22d926e7945812b"
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
