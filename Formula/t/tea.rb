class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.14.0.tar.gz"
  sha256 "f509de217ac0e57491ffdab2750516e8c505780881529ee703b9d0c86cc652a3"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf92d8a13e8cc2afeb97674055e165b81ef33842d5ab7371409d2537a000876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf92d8a13e8cc2afeb97674055e165b81ef33842d5ab7371409d2537a000876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf92d8a13e8cc2afeb97674055e165b81ef33842d5ab7371409d2537a000876"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b6e690872021fb12885dd8cb25c7805a482e7603625f782612b94dca67f382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "358b46074556a21853cdfd65e2f3c52b359df27fa0a0de8d506cf1b4781cd68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7023b8493115ded2d7a1f739d260d203e88dfb89369e15614f4eb17e8106048f"
  end

  depends_on "go" => :build

  def install
    # get gittea sdk version
    sdk = Utils.safe_popen_read("go", "list", "-f", "{{.Version}}", "-m", "code.gitea.io/sdk/gitea").to_s

    ldflags = %W[
      -s -w
      -X code.gitea.io/tea/modules/version.Version=#{version}
      -X code.gitea.io/tea/modules/version.Tags=#{tap.user}
      -X code.gitea.io/tea/modules/version.SDK=#{sdk}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"tea", "completion")

    man8.mkpath
    system bin/"tea", "man", "--out", man8/"tea.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tea --version")
    assert_match "Error: no available login\n", shell_output("#{bin}/tea pulls 2>&1", 1)
  end
end
