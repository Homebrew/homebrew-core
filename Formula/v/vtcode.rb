class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.66.0.crate"
  sha256 "9ab0f6c51949997c5743df4b65c110832261307e7588c919e89947bcff29eef2"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb77cbd48975481a7ebd2c49e7b964207515e0a09adcf97833de8012480143ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef17e0dc054c67c964675f7e779a16e3267c871f065e10cae71853356d05d6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bb04f44c7f6cf5c77f2d53b640955bf8bbad05ecc8232ea9dca975c9e774e5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "caad8f95c92453cc021d6dc0408d03adfdf4138b76291a09afc0d9ce18537491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495579117018a55e14f801158864f10c8770526dd8c9aea1a873c24a442799bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f95db8f4f473f17eaa4f4e53d55d8ed980ffe5382b3c113448146062e26516"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
