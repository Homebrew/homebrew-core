class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "f6b8a2481fd15157c0a5ffe0a10bd9f881ffd56937491c0b8cb12c684a1b1102"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04b2e40afa567a7b1104417ff5993f21f031589a31c1b1e02bd0bdd24b4a51b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d9e0ecb7aaf5c3228a6837fca6f4063b71c1806c08887349444d53e82782fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b47e491eab809d1af44777803b50a474f35b39cda104cf7a691a45f87cf080"
    sha256 cellar: :any_skip_relocation, sonoma:        "90bc4f83f3db193d04316b5ce715942f72d71d7cec5a3faa8059e61ada93b244"
    sha256 cellar: :any,                 arm64_linux:   "23119e1d60a86d2d7047fae83e3148c54ba9113ce9b4ceb38cfcd4ee4f807c3c"
    sha256 cellar: :any,                 x86_64_linux:  "ddc302b90a4368a2192c8f900d49b7ac81b389d808fd02bfa1af0574267c1fc2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
