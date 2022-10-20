class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.0.tar.gz"
  sha256 "b7658a074508c117c2af3a55b7b37abf194f84fe94939c9b6b7ff324696258b9"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ed7e62d0351ce4fa2e436d936cc71c013ebd8b661c9089b07089b400d96bc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fccfecbb9112a710228b5ceb620fd3454b4c399109d8fc26bd5842c8c24195"
    sha256 cellar: :any_skip_relocation, monterey:       "6a01a3797506300a0c9330271c166ef7c5df2bd106ea2673e54351471c80c45b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ba3da0603ccc227287346a7d1b42a588b34ccdfc0ddd461279f1568ae66c007"
    sha256 cellar: :any_skip_relocation, catalina:       "99aa421cdb6f6ab65af67ffb7adfd38f7ec5c1b97d1243179d7808a8db34b202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3bcf729083a050eddbb4ff61a27183b72844728dee08628cc469ecd4456989"
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
