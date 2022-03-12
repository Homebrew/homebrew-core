class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.5.tar.gz"
  sha256 "0f6e735969ca1531f05ff995a7c546eac27c3d1ece2bc0fcc0d75de8fbf8fd07"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a5fedcc4e3d26fa8926c73dc47318ca45f423ec760ad93c937863ad13a00dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e98fa646d7fd9f624fdf7e3dd117c4840ddb01c09c2b85a65ebc521dad17ea08"
    sha256 cellar: :any_skip_relocation, monterey:       "0433b2e153ef27b0766130205b80ed902ac3d8b948b1c08d0712208be0ca187a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4a06f474fc7cd0fb93fe9ae8d842b34cab5a9872a5f4a875285ce401dfad88"
    sha256 cellar: :any_skip_relocation, catalina:       "bd68dbb2a2b0c2121c9fa51b974d0d2db48503218806b1497fb7e9a7be80ae54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7505477ecac7ab3badde028a01367a307e813f47b16b78d25de54a26725bca34"
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
