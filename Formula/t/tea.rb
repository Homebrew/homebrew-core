class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.2.tar.gz"
  sha256 "b5a944de8db7d5af4aa87e9640261c925f094d2b6d26c4faf2701773acab219b"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c12a9d559cd244dbae08c5576befbeb130106654a28840949dec0ae5eb078a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c846ba5d6f06a8023e00fb1660ab42fe5b5721bec548d4ad8d081f1f1162808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "101a036947f27a6850e4356266d655f3a9eca0e4ddf945d03a0e87edd44c77b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5154683b587810feeff9fb1610addacb6f767458615b16cdf7f2716b8f8bc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836a04b635e7169f1f65c915e42be219955ad8f2ae9ee277d8d4aa385146c7e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "56633d78a45649bd716f7f555c861d9bbe2778888d0cd8f97008036e127975f1"
    sha256 cellar: :any_skip_relocation, ventura:        "8cbab052ee3eb98001849dafd4a7e2eb61825e136fd329959d676dff58dc86b0"
    sha256 cellar: :any_skip_relocation, monterey:       "dcba430684c199e5c6a59598d575162b349a554fb228ef6b0f021ddfaf48b527"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f5ff51cd8dc6135d4a19f48773e6787721ff23c8a659e4c6b9b3cc64f35b1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9706843d0c5da833fd35d91ba80f3b706172947e7fc4c30274b9a48d77bd6f"
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
