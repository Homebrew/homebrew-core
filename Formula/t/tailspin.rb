class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/3.0.0.tar.gz"
  sha256 "abfa5621b5750c892cc1429322b1ee664e1be9808eb451c84c113fceba2d0d92"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db6155b4f802d35feb456ab02bda67c1a248aef38e58b6ec4d389d8b6b09de5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e9424288b4782b9c3ece9e12ee4ce681286f30da8213572d3d88e830d79d93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef75fbc9df01004c30b32f382de6dc2e722dd9eb8ce5345a10edc4847c076d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "31deb327cdd044a66ace52c2fd7215a2f14a48db04cb7b75ff01162db3f6e859"
    sha256 cellar: :any_skip_relocation, ventura:        "33e6041a1ef2b94c06380c7d93a8008f13136ebc6ec594d6a21e3c4ad384b937"
    sha256 cellar: :any_skip_relocation, monterey:       "3e142b79f947ffe786ed33eee79fa7ba5b22a8d2465b74e4efa8ca5313b114c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6c8a8fcac754d573217cdbaec7fdd162a3a1000f02b8738ddd4913ff8ab9edc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tspin", "--z-generate-shell-completions")
    man1.install "man/tspin.1"
  end

  test do
    output = shell_output("#{bin}/tspin --start-at-end 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end
