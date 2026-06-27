class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "60326eac385f71d6377adb9aa4a4ab04b9a5e359334c216a794d741afa4e9e28"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc576668db573abd3485431afa387e00b7a43ee8184e3b032fe3e66744e2910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3d795568c532adfed374c401bd5f3449af1ce55c6bc8e937208bce90c24f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f1360fa03d2352b94e42793f577b92e09783354919eb373dff3b40f32d7ceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a3d84f036a8e954d67ac45e56fd385425ee9b7890bfa63ad67ef1a4882a519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4157145c719e6e680736f86ad0da9c54456bd02fcd0f0af342654fe63f64bf7b"
    sha256 cellar: :any,                 x86_64_linux:  "8d52c9b7c64c5dc85cb262b324cc7dd9dd7cd9d91d3c3167e3e72d0c675dda7f"
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
