class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.11.1.tar.gz"
  sha256 "1da6b6d2534bd6ffb0931400014bbdef26242cf4d35d4ba44c24928811825805"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2bfa35ec5ab4abbebb112d8a0fc9e9345446a8adad4711702b8add6afb6b246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2bfa35ec5ab4abbebb112d8a0fc9e9345446a8adad4711702b8add6afb6b246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2bfa35ec5ab4abbebb112d8a0fc9e9345446a8adad4711702b8add6afb6b246"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d453ba641dd34c5bcebec76d1745fc7d4d98e01e92e412091dbd231b0b9a91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f69c82c69b48dfc5edba4c6ab98f1eb470a40b6f48451cf7bbd6e9fd9f8c02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b60cf1abd449ca7d8c0c4dc0591dee476b861dafc5c544618e8e6fbf60f0747c"
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
