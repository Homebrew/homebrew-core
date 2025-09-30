class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.11.0.tar.gz"
  sha256 "278bbdf2e197f6f80a838e09574e8a950de535f0ba0f53154d26930a3adfaaa6"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf341d370a6e754b0b6c892fc6f2f40b6404180add2d56994dcf59de7a3da9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf341d370a6e754b0b6c892fc6f2f40b6404180add2d56994dcf59de7a3da9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf341d370a6e754b0b6c892fc6f2f40b6404180add2d56994dcf59de7a3da9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aecd03dd5cd0eacabc0e78fd3ee8ca55067f2568e934f57cde586336581ec66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c998a91bc984ca9df6ed6af5d598180c020ac7371cec6e7b86d319cf2d698993"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"tea", "completion")
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/tea pulls", 1)
      No gitea login configured. To start using tea, first run
        tea login add
      and then run your command again.
    EOS
  end
end
