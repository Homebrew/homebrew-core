class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/6.0.0.tar.gz"
  sha256 "fb8ed60a4a0e863304034d6f73e115183a9a27811f4a0d2afd76151a547c40d9"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "546dc29561a947ac2e367bd339121d47e0bf1a97d48d43b30889226141132091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5a97178d12c7b9346634550514aff9afbe097abe894640cf919f34b533f88d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "173d8bcf4e683adc95902ed9ff8b9a309db9360148e6ced916ae6538816a055e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d916063441067bd750c5cf6fd5f328d128639a76bec5dbbdc5ddad5a4e5919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe541e32db49822f3b3fffe94f1f8865cfbd9f3540b7528373a4b5c1049d07f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280800b5943da17e4ccbd7bb0ca6d0e284c71276663c83ba1b419add06133b29"
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
