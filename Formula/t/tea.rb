class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea.git",
      tag:      "v0.14.2",
      revision: "88f5cdcafadbafd992cbf6ea31f9f29512263452"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "631c12e1cd0d3a577ac725b6628047c891f9f96ff8c9c211537735b403577efa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631c12e1cd0d3a577ac725b6628047c891f9f96ff8c9c211537735b403577efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631c12e1cd0d3a577ac725b6628047c891f9f96ff8c9c211537735b403577efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5deee6bf39583020b446b2aa4b5bf228a077faefaddc6d661b84126a01b7037f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d379327eba2318746591d87221ab14b9373b845d6fec1346517af068989f58c"
    sha256 cellar: :any,                 x86_64_linux:  "8cbfce4fd2342c7caac36823126dbdaf2ddda34b049b649c10b60ef5346c298f"
  end

  depends_on "go" => :build

  def install
    # get gittea sdk version
    sdk = Utils.safe_popen_read("go", "list", "-f", "{{.Version}}", "-m", "gitea.dev/sdk").to_s

    ldflags = %W[
      -s -w
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
