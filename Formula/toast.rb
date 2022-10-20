class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.5.tar.gz"
  sha256 "3ed81317edfb312cf79f479f98f2d5a7d0351c349fd054c602b186376c269e01"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7878118bced568010e51d7fc0d62fd4c6629ae8c6db4f3dfc963bad10472372a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb076ef03010b05f758342ebd8d37d704658aff876bef4ab818352a496f5fae8"
    sha256 cellar: :any_skip_relocation, monterey:       "fdea9e586ef92aa212bc0d2614ca16de8f63f86a1209700112391d84a92a864d"
    sha256 cellar: :any_skip_relocation, big_sur:        "567c443c357368ca29fed892b08c1104076abc50875d95c48debe995c6a4c1b7"
    sha256 cellar: :any_skip_relocation, catalina:       "77407ff16b86e663e913a71df295b2e5520ebf79c7d918f61ff8964104b04001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb998cc81c56d4212bee847c1cd990bb01d122042eb2fc762df22fad9223e96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
