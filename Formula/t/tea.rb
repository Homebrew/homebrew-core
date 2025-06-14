class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.10.0.tar.gz"
  sha256 "16cfbab7cf3c53d2291354d214edede008ab4e526af1573a3d8b5ef3cb549963"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e5dcc9c1edc11e0b9a0aa340d3b90169b1b4d9f4c2d30713761f7ac87390d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e5dcc9c1edc11e0b9a0aa340d3b90169b1b4d9f4c2d30713761f7ac87390d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e5dcc9c1edc11e0b9a0aa340d3b90169b1b4d9f4c2d30713761f7ac87390d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f44266a6dc54bf6b3776318666367a19b292c73a9cb8076f70aafa9cbe5b1e4"
    sha256 cellar: :any_skip_relocation, ventura:       "0f44266a6dc54bf6b3776318666367a19b292c73a9cb8076f70aafa9cbe5b1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251286d00306a5eedd0039b39a196c9106ed9234148e3f4c797ed7fb23ab99e5"
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
