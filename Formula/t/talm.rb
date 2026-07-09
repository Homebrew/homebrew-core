class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "487eae755c8900ca68b8800c215c13996645305c960d85f2ba4cf99ad0ff4147"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b791d9143aee6c9193a818236af81fde3d250a862881cf43f05e5a3e86be33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8fefea6bc69e3aaf167f0f65a51b6c3b6db42978a2d5132884b7a9a67917c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9232681bbd19919f55f3dc732402e22b45b0f2539740f9bb2527fa857a91e5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea91ce7fe4c1fac91068c88d4fffa414d4cb95da8f86ecfa2ad178531fbe2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea27065392291d59744d6873df2745d6e4d3541bdf16c240cea423e95043f453"
    sha256 cellar: :any,                 x86_64_linux:  "50f71326e6f9e5f5cdd65109b4b76b7b4fc2c1dfc87277ae2b0858b102b679f3"
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
