class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "1faa7c95bde5db6726a572fcfd3ec5cecd13691382015dc75a6ffaba54991ded"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ab1f8245d91d622254ab21fb7809b88401579b0f2a42966f9b647fe7b8608b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84895cf9a9a8ac0abdd2e40e0641e10efa1bcc6749502f7e77bb6d82621f94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cff7c95451d42852c5f72c93afd982e6150d065aad8a18587f85e4320307167"
    sha256 cellar: :any_skip_relocation, sonoma:        "515d1946920f0d318fb1781b77c2d0d32036fffb239e8243baf287f66533fcf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a417be05676b1c60e56f86e63e8d70e00404b985aeb97aa3fcd1e5737ed6a7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b998f279832af91bd2e4b4c5b4d04a6349329a2c18924202922866ad7034a519"
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
