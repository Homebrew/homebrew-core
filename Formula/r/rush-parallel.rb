class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "3f2901313ee279818e6230b432d48b0bb0e1a681ca83740f7e67975ad8b95dd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0341186dd90a55589dc401216afbe40913f3112ab94d6c4d9c1495d99cb84dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10bab20218ca91a20f7b7d4a289abee8522d5cc85ae88183fe8e85b27a03c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea91cdd222d0bf25c6dba7f67e544d2c1e9fc13fc313ce8e59d06b52e838024e"
    sha256 cellar: :any_skip_relocation, ventura:        "c4f91f1dcf5a639e422ac42f3c23fbe8b0bd7c1228123bb4f848e1942eaa8482"
    sha256 cellar: :any_skip_relocation, monterey:       "f82c1a66aaa1ae0723c14bfa3f598fcb0bbed3f7984e36648c63460226d34109"
    sha256 cellar: :any_skip_relocation, big_sur:        "1900017baaf28aa3f39b99c19d38442b80d35cfeef12b87a788b8953212a9a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648aa2077757ce3fb989e9c2a0d429861817cbe2e6c3746e3f9243ab15c9fbf4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
