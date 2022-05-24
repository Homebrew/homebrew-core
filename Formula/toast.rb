class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.4.tar.gz"
  sha256 "b9b7198ccde0c2a999272ed8f0023125f03162f53b9bb0991d8b8e83a309c151"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97460f232581c14b86be48a55d7bec4c3e2c591cce77d30e647b4ba9efa367d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "604c8f1a6ed119b6e6c2d716005f320975b520175dc8dc5f56efc217b818ada2"
    sha256 cellar: :any_skip_relocation, monterey:       "41e1ecc5734166aa4b743634f118c2c89d328a1b7e248ab008ac732c6f4cdd28"
    sha256 cellar: :any_skip_relocation, big_sur:        "724bd6ed2659a9ab5da7c6a764d8e574b6611a0185ed71edf32a27ca8bc20a1d"
    sha256 cellar: :any_skip_relocation, catalina:       "5bfb4e468bb3b76aeef89fe43ea31ca73e3eb4457f1373ce00a7ccd186620b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55cc947eec52969fb35754829106a28f7d3595cdc35583345bf0911b33a459f8"
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
