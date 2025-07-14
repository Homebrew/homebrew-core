class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.10.1.tar.gz"
  sha256 "791b7f90eff9ade0d5ee5e3f0dfba128e35eaf83b5f8b8d5f5d6cc9a94ae9b03"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "583f5f467ac41ee8780036f97b3c34e6e925c2c8175f17eed3cfb42401c6b982"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90e4b3e7fbebe0214ae29c379b4b8b6fd5e8a7f37ae470e7b6e30532673eef9"
    sha256 cellar: :any_skip_relocation, ventura:       "f90e4b3e7fbebe0214ae29c379b4b8b6fd5e8a7f37ae470e7b6e30532673eef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c4fbefda1ec421462275236ca561d2166d334f9cb6c36a66328a41f2eb720a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    bash_completion.install "contrib/autocomplete.sh" => "tea"
    zsh_completion.install "contrib/autocomplete.zsh" => "_tea"

    system bin/"tea", "shellcompletion", "fish"

    if OS.mac?
      fish_completion.install "#{Dir.home}/Library/Application Support/fish/conf.d/tea_completion.fish" => "tea.fish"
    else
      fish_completion.install "#{Dir.home}/.config/fish/conf.d/tea_completion.fish" => "tea.fish"
    end
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/tea pulls", 1)
      No gitea login configured. To start using tea, first run
        tea login add
      and then run your command again.
    EOS
  end
end
