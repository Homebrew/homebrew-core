class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.6.tar.gz"
  sha256 "d91c8d2935f55dc6f241b7abc0325863846bdeac07a8f3bfa99b4a932d20ace3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9285223361b339085b9493c85c54ae1159d7aa18629f781486570da215759762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae70bca81296c94bfb3cc5b7d44c66823b8f4e18948b83c2c44a947559669fc7"
    sha256 cellar: :any_skip_relocation, monterey:       "707e75797f8c2a14149c81be5ccb76931711096ef05bca605f78277681db34de"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcb44ecf691dcf539570428efeda8ab9e3235f60c1653873d917f770f9283155"
    sha256 cellar: :any_skip_relocation, catalina:       "4eb1c753639f85a936846589e27bd948fc09ce659e45158738d6b18463a796e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a6f00ddc6c233f50bb6d103a2929740fb02d02fafbd6b4f82fbe0ed45b2428"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "bash")
    (bash_completion/"s-completion.bash").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "zsh")
    (zsh_completion/"_s").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "fish")
    (fish_completion/"s.fish").write output
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
