class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.0.tar.gz"
  sha256 "b7658a074508c117c2af3a55b7b37abf194f84fe94939c9b6b7ff324696258b9"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6f55b7cc1820df14e9811d4bc07e64955fb8941b20aa966423cd8899b51172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49e489bc4e912dfa35bb7e7b705116abe414a4b521af23647aa5cb0bec5ff2ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b1ff8af1bbe8ec4a642a35acab00f997becbb2cdfa36322a2599de6964281ca7"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c29f84e5706464b5f4e755179706727732f449c2a9ec76f183e51d2f220952"
    sha256 cellar: :any_skip_relocation, catalina:       "3c11613b652e2f3336d0decd2477f565584fdaf2456d042893e95a30d0dc2102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1335b013d625a316a416ccf89babbf84e676cc90243972beacb9b68006d10c30"
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
