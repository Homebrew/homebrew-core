class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.2.tar.gz"
  sha256 "edcd1e9af43c91c653b19ba2f58297b4815afd285657221282321ceb2930c537"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29e52360a6c2dcb368442a59161640e1cf96e565ab59d1520e42c6a2ce38b7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f95a8d47dcb61111ec3632dc2406ba7da8ce2cfe1da0be65f1404d486090b4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e019cd0a45c2234d98059888ee64645ab9770caf44be38d5316715f965eea64"
    sha256 cellar: :any_skip_relocation, ventura:        "1046864dd1353e9d099c60620a3e7f0c987538ad6f97718a8680cabf620919cf"
    sha256 cellar: :any_skip_relocation, monterey:       "fadca52e0a62f26ea7eb13db0c68b598d37612e27bbff34d65b55b8ab77a238b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7893a8ecea71ac9be6a7667957e5f5056be4f30ca08ae82e570547d58a2bd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d697d3d95d709675428a104ae1cc97faa3ac732054f612eee298e664829e21"
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
