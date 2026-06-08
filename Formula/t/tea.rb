class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.14.1.tar.gz"
  sha256 "848b6b2fafa270fa77b4e278d521bfcc16d2f721c45ac90f08f5b16dc630c3f9"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8002beb5d9ee2061005984b90a21f7414292fe21d58b3e38ed4d6c3d35ef4304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8002beb5d9ee2061005984b90a21f7414292fe21d58b3e38ed4d6c3d35ef4304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8002beb5d9ee2061005984b90a21f7414292fe21d58b3e38ed4d6c3d35ef4304"
    sha256 cellar: :any_skip_relocation, sonoma:        "343f8e211413ae14e71279aa52b91f1ab00c7001bb00e459ce2818e26ed136f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d1a65bddb69f2f4e2d9a6a7f76f5df4db3533fadaef90416fbfd5e2ccafebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1b2c7a307df6a8549827cfee645eaa43e23b07582baa412592119b4248f00d"
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
