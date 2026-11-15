class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.16.0.tar.gz"
  sha256 "3c8523e551f576290c69fe6375208e0cb27d4fc1e48b29b13e02ca6ada851c05"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "677a799772b1a4fbf7c2c226cdd42e7c9ab836b1cdeacdc32b266c15f44b70e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "677a799772b1a4fbf7c2c226cdd42e7c9ab836b1cdeacdc32b266c15f44b70e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "677a799772b1a4fbf7c2c226cdd42e7c9ab836b1cdeacdc32b266c15f44b70e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "677a799772b1a4fbf7c2c226cdd42e7c9ab836b1cdeacdc32b266c15f44b70e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fcf3de9e67696dbcd4f9c2c4a51277e70bbc997c75d50c44faa0f507df1814fc"
    sha256 cellar: :any,                 x86_64_linux:      "4c745d0d25e85a93f11252ec997fa4326c015813a678c4ddbb2ba81846f007d7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
