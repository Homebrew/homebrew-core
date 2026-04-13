class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "6bad90ebc5d6753c8fa895e7303d74b48b5e6835c6960cc8500fc56598cbb044"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "953d83ac552b0804a258e896b7e8d8249b8eb90d2f7b33a9059b29cb0afaf6fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd8e7c812c3339dc0d4a3bf3c89888d305a6b61d89201b205a3d23521d50cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23bedd08a39b10853a6433ff17b95ff02efb9e17df10a3dbf468f0404e11ac44"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a45f36f1cf5bade2047ec63d182fa769d579c2c350a87b9b8bb57f508af213e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef4a5dcc78caff46568451107f8bf7e22fffbbc8420df364a6790f39c23cfcf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5588bf1df0e8240237e67180311b514a00229a6ce39f04190e477070912a1053"
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
