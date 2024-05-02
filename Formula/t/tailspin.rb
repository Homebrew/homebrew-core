class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/3.0.1.tar.gz"
  sha256 "1aee2b9dadeb90652ab648b2c23e9a6721ca64ea5cd2fe189d2d53aff15ed04c"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "127a486ab195a0bb94ee09f5f271510a577ce481fec415c1da665678a6c741c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53c8d3643aa7d21cf0c8b3d23d55ee73050640af83edc43b4e05b0e0c3919bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7136bb33ec68113cc4823acd7cefeddb379a363dc0cae215bb010795ae2176"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd884739a33fb4e02e358fdbd6a246036e1b1f38ee82e2d2dfaf7b1b8888d1af"
    sha256 cellar: :any_skip_relocation, ventura:        "0ebfcfa483302697b163077040d2a2d01d84c078c9d281b305de221827eb64b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a19d61af0468af5f673648aeaedde85c754f5f8ae80f2d95f46f08bfdcd34d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6606ac3e9db19a967a34f345509fae6e8b368d20d5a4dce9067348cc9daa8d6b"
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
