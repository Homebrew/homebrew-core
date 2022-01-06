class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.4.tar.gz"
  sha256 "5829a18da40cb5a936f32240b4244d2a0543cb85dc3d5e013ae5aa08557c148f"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396c7a1630482952558eaea572dc4f5c307cd018f1f0ecebe3f0bd7a826b0768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f4e181f77ddea9fcfa26d373ba9bf5e0114c378a5cb63cfa34f46dcdc3da8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "3599796baf841cb89dbf555ec7a064ba1fa6837817ad3d0ca2f06191d3c9955c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaf00c30387c2dc0fd2a43f00f146ed591cbd59f35acb3dad86f71e890685f4d"
    sha256 cellar: :any_skip_relocation, catalina:       "ca2e662bdedf55811bb2437f3423899446c68880cf1a554eb1cf1374db9d5f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6338dcaacf12fce7dc4d76a0dfffe930bea286567c382f2fa7736dab7c8ab6a1"
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
