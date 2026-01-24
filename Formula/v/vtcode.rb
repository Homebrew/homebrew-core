class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.70.0.crate"
  sha256 "c7247f644102118bf9326c7be10fc800fedbf3db97faec924527619a2f26f900"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e44cc23293a1b6e49ea962fe2b89dc2123a95511a05761850f9224c3538d4b00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d56ce58ab062280cdf8d11438178aa032ced0a13e80b1f870a2e128de43c81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5b31d2c256810349fa504117cccf1e9ceebcbebdaa14145cbb86ffcf71a84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f11a5100bf0301ac9b898ae798b04d6883ee27fafd96ddaa2d8ef69df1f0de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde61e3441b35d037f0d49cf7b63a9679dcaebd33c757a99fcdabb18755612f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e67887f145d677ff792df417b571ae86671fbb39756de8350df24674aba62c"
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
