class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.45.6.crate"
  sha256 "139eb54b670073483f6178fc82e08ac8ac5f2e00e4d4cdcf20d6b0135467405c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3573eb3a7d9606c92006eeca62f452e9aafd19e976c9dd5d917547ec120d947a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b3db7b4228a6cc70e1924d534e864458e7a8f40ee82f71b49274dadb30ac7b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835b6d91cf9b30cc350057cc7304e697ca7f85f397db5891d772190bbfa05a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aad6ce2e6404fa5b4dba5d3834bc85075629606145b3ccdf5dc2c765a2427b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f20672b0cb31eece9230fe0371ad6ade0d7586677df0748a6de00c507c86150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d654a449843a3e71ae44e0bee103048a6ab24a48ae4110e0a606f7c54ee05bc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
