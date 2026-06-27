class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "222c6ca439103441c7c2169351b0aeb841c6f5eca985c07dc53f131173e5c2a7"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60063d4a31c92fff77c14731b9374bc1ef0523b637da04bcebaf8d347a747916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867c3a8ef068fa0860d6cc658a9ece38a8ccee47d4292d5350f51575d88526fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "913cbe4f52c8917813b02fa1bee325d612d6086983c3fb3b13a44724a699e57e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07375f38c2871a8ef30df5d868bc8f9178461c30747d7f83b1bc20a1fa8f440"
    sha256 cellar: :any,                 arm64_linux:   "c66fed44abee535dbb20d4b1b45b3bd83b7104afbdb5d5c76d869939112b9281"
    sha256 cellar: :any,                 x86_64_linux:  "9ad8d2ce3afd8b7ee43eb254431fbd455a056abcff17482376d9ad7357b24e88"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"src/main.0").write <<~ZERO
      pub fn main(world: World) -> Void raises {
        check world.out.write("hello")
      }
    ZERO
    system bin/"zero", "init"
    system bin/"zero", "import"
    system bin/"zero", "check"
    assert_match "hello", shell_output("#{bin}/zero run")
  end
end
