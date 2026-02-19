class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "ba7c736207df621b3ca0590842bcf0ef48c63be34d69608e44bfc01eb4a2f848"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c6a62b6e8e716efac964c63e03c651025b0d5991c430d443e78250b5623d48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4524b5d379f6172884ca205226e8a42b098ac6d5a5a25ed048576a155fe8fc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2f8bc8b6f8492ab7c60a179fcb693632d56309ef9dc571287ea7e1bd89d36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7926fca6d11afd5ad45459278ebe727e24557a8f19014744659290259da479af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd762bd859c8565e4040737f0dca905790a39996571a02e5794e7a348c40e301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303b6114f539e56f36eb5529c1c657076555915947424f1721f034405d0ae01f"
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
