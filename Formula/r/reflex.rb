class Reflex < Formula
  desc "Run a command when files change"
  homepage "https://github.com/cespare/reflex"
  url "https://github.com/cespare/reflex/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "62603db35a51fddf8a3ae9b1f4d9a8372ebec2a4523be16e3261bc8f9cfba3e5"
  license "MIT"
  head "https://github.com/cespare/reflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b134833b43caa9d4fe46d6e7e44c53abcde8ab5a0b8749c0f79ce74597ee92ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b134833b43caa9d4fe46d6e7e44c53abcde8ab5a0b8749c0f79ce74597ee92ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b134833b43caa9d4fe46d6e7e44c53abcde8ab5a0b8749c0f79ce74597ee92ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "0880dc91da7a030d1e9b2a75681db93da4f93bd4c0877c9139472304688b2786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b722627159386c0757c68de414d025136c73fd72d6ff0841a8f8087321b46c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d01e74d136d559af1f84533567c7c91b30a946809b3ad49ee25d3a0133ed701"
  end

  depends_on "go" => :build

  conflicts_with "re-flex", because: "both install `reflex` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/reflex 2>&1", 1)
    assert_match "Could not make reflex for config: must give command to execute", output
  end
end
