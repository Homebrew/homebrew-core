class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8f78221b059defa34cf05637ef1f6772adbcc8d0034efd701ec1f1969b57724f"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce762367b842c0587840cb83eacfeb6c80c6ff636b6c5eb2e9bb747a5f9c6d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2027d41ef5b9d67946917bd153db16f3d067c08ddcfbdf7b00799cdf4280f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ca1c2ddf1c966d31e19e22582889a35f2fda499ccd8cb0496ed1f5bcde8390"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4c52839a6ff95adcf4105e03711a504f1190bd57922b090c1b8c0007e66e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ad90fa291e434428f51b17ad36b0fe5fe148d2fc611c9d22b3b7a299ca7304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa952691979cee7fa439459ea53b828b161ea6cdb36adb740422e4d5e72c361"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
