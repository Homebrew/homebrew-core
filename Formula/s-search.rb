class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.0.tar.gz"
  sha256 "0019e21dba7bb30e4de279b71e027c7d78f3236d709c2fe5be39b38d22aa7097"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86eb423733972f1501502155b72e22661a8266fa433ade90f27e045dfb0c6de3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f11b7632fb8b306788d486d54b53feed63f7dec7c4f149fc2a6bf716cbe18837"
    sha256 cellar: :any_skip_relocation, monterey:       "382b04e8468aa53b3262bdc505cf93d85c8bb0df45ffdc6cf877c76a9c6c1727"
    sha256 cellar: :any_skip_relocation, big_sur:        "e37573825550c63f264efaebf0f9331034fa722cbcff2f41480e3f36663b6a70"
    sha256 cellar: :any_skip_relocation, catalina:       "71ec2554f4cb3b04e2cb4bb871f91b80c102e0d08ea42cc9d9c77c7828b8c20e"
    sha256 cellar: :any_skip_relocation, mojave:         "437a7566955f6c381b81458428abdae3ae01dd124543cf08212e1617dbbafd65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a06b8ed3430c05ce0cd462284da8fdcbdea88f023aeb71f965804bd3d97f95c"
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
