class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "defdce484f8c92f265e1282490572575028967c2c55d356111d1e49a3ea9a88e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1aca6904f51e3f5922a1e98652c57de939ce1fdd2a69badf7b54e4ba0f0b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f3e8cbafad64e9989ccc6e3ce299d147c7303090e0acee1926a90aec858779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418aa7c12129b1f5ac8ceb59f336b2445501796bb0243dcf580c838187049cbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f040ddb667a0aaffaa71fbe95efe80d3fc5e3364b883b01c8d39b3ad1e461a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4237f34bd27890c27da7e46c695f9f91c81a78dc93054eb5d99f9d31cf040a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea1ec779f055f3548f8c8b1373a6213311ef9e115b837a3f9c55499ff7638d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "sd-cli")

    man1.install "gen/sd.1"
    bash_completion.install "gen/completions/sd.bash" => "sd"
    fish_completion.install "gen/completions/sd.fish"
    zsh_completion.install "gen/completions/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
