class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.6.tar.gz"
  sha256 "d91c8d2935f55dc6f241b7abc0325863846bdeac07a8f3bfa99b4a932d20ace3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79e0b5d4ce85ad4c648a46d315021a6ca0dcf1a89023df352e48ff20c62d13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ce8039df0464923dd108ab72c4799b31ea4f395efea027bd6456f3637ec5f8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3ebfa69ef29c3423fe9c8b15ac391e4582760822185614263c8a7c2709bbe6e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "eac55f5d82488848feeec851ee9c88560a5ac81a113116329f5e430e809be7a5"
    sha256 cellar: :any_skip_relocation, catalina:       "038d686786ffdb37b219729d448b224b3e0ec469ece4740d563f2fb6d540909d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40de6a2bd36d0c0f5df5b01bcbe05905e4f9916ded0c9b2853c9819cd3779e70"
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
