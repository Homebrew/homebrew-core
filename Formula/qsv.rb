class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.75.0.tar.gz"
  sha256 "3f99a94a7221e02f31dc75101167368582a4bda0f22c57fe8540b724d13733c4"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d66599722505e5a27616a5feaea5829ac0ca8d93b93d08548cb245124a2e15b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40bb87111b5505c7b24a207e8e8294146472f32f2e49bebdf232931badffbbbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e33694a89d33f3da28868566e1573df2faba7dd6dcc7db83a836e0f1bfc868"
    sha256 cellar: :any_skip_relocation, ventura:        "214039d66c7899047277449a00693e64c09f8b27ba73fc4ae17094e2c7eb3b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "14807c24e8a9af2fc565719075a65c7e1815ad36dee09d11d9fc44259aad67ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e052bebf449ca848ef5133f9514ce08f78f224c28bb78c8b3b37da4a2bb5e8a"
    sha256 cellar: :any_skip_relocation, catalina:       "678e3068a0d2c6421bf7800533a7a1ed8839db7a689fa1bf9cf43679026f43ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1136ff15d5186246bd5820f7b1d3df83960df443bd24e42c98d4eea7743a145"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end
