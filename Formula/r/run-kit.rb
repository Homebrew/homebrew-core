class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "307626f38dd9a13c0f5f28b971c731e46aebf3518020bc049b051170e49944e2"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380199dd143b10971160564c14ef1b13f89c0629c021368b85dad8aa8bb6480e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7a08f8b5d944382edfc3db55f203ac19e40cfb97560586c2ebbcc1c6cac86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee991997710368c2f0d72b806f94964b473c3313b172d9466aa2af0f1bb0b662"
    sha256 cellar: :any_skip_relocation, sonoma:        "db3484fd43b678e09b5aaad3b59d26be6b80902dde7984de579745042f60404b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970ebfae6cd274de6e0c0f1d91adadbb0a296f047297107af582386f55f4f0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3f3850f735a848d5ba672299ecb11e7ea248c0dc922262e0dde556e8855d1b"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
