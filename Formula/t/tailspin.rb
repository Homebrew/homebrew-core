class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.4.2.tar.gz"
  sha256 "2226229e6c85859a094bbe4e672a467976d7563fb7ba0454e75135c2a6537ee7"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4856acada71f24fd48aff031e21ea3bd5888288326839a8d29d3aed474b0d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ba0d34dc90e489fbd05de60b6544ef635999c80edae36ce95c259cf491a1bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b72a972afdc4e9e8ceb5b2722f9f478ff91d7c92bb86b5d5c643fe69e1ba095d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9569242f88d6318b8936c33f93bda3640318153a8e5d2661c1034e51d7cb4ef9"
    sha256 cellar: :any_skip_relocation, ventura:       "c111499b2b53ac56478bab4b45b721d7a77e4debba044510e915a3cac25ff86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5fb2a7e972879ff7044d0c7bca1023be012e6eac59ad60e5b965cffd7e05ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd37dda4d3e11e6490b1567053711275ff7bd053fed8eaf24c270e013268ec4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
