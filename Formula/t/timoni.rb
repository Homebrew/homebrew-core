class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "1348744688edf0ff5b74781df0b2a280f46810a13ddc458bd2ede5e2f9f72a05"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ed4773ada96eee11b939418751187e1ca47e5235e59534f08a20e6498d120c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ada071d0ca7c0c439b30688c7a461de9dc68d0dc539b78196e4d9a0430f51c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "683a8f39929f637f48ab4313603b2379f2031fba53e4cbb94ccf3166f48069aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ab010a336e67dbbae88fca0f8f4cd30d08072728b6cb70f30b0943da70d18f"
    sha256 cellar: :any_skip_relocation, ventura:       "0c53d05d331ec52364b39e61ba79bbacd5c842c41f7d0d1b08984d53c7430980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd87b2828b5879989cd64ffbdee9b6e0893087c8a032694cc3a1c922966e1058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6eaa213231e9c5dcb9a7022e196eec2b1ba11e65a24b6a031cff89e1c5c073d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
