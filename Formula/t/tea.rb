class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.15.1.tar.gz"
  sha256 "e242dd3589c31a36320d75e0de9eefa3fa429bd9b0af89d35af8585c7f514b9c"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54f1bdcb08d994706ee7ce04e0e2190d787c1ec665cb778bbe8770b541847b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f1bdcb08d994706ee7ce04e0e2190d787c1ec665cb778bbe8770b541847b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f1bdcb08d994706ee7ce04e0e2190d787c1ec665cb778bbe8770b541847b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "774c7b915e4f43bb3d99078f2b79f019b745cd88a267a460a6a2b43e38d9ab6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1046e63c3eba3c99560d88dfdf18f88282d35f1022e2487ce782fdc302f7ebbf"
    sha256 cellar: :any,                 x86_64_linux:  "e09c16b9bc6ccda503faf3a5aae658f64fe23e2305d8d1579035e41bfeb3bd5d"
  end

  depends_on "go" => :build

  def install
    # get gittea sdk version
    sdk = Utils.safe_popen_read("go", "list", "-f", "{{.Version}}", "-m", "gitea.dev/sdk").to_s

    ldflags = %W[
      -X gitea.dev/tea/modules/version.Version=#{version}
      -X gitea.dev/tea/modules/version.SDK=#{sdk}
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
