class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.60.0.crate"
  sha256 "e74274035ad620ef8b7c73d7dbf5b096bd63a51c06bb60bb44cb9f394b33a567"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f026e0a388dfaf9a4d6eccf76204976d77ba7e605ee9643340ffa849ba1d522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a9334f3e88233c763e69b5c61d47acbf98efcc463b6c58cc9e4300c62112be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeedda8fce848cea902e15639eb04c2234daefa6b1c315e3e685523bfdfd842a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9ca5fa1ca738f55eb802ff40c416bbb49ef6fb1e5ca5a317a51a108abb33c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b17eea37add119e8764f3718cacca1823c3c555af7134fa90fe102a8f6b589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e50f49a0d3901ffc2a25dc0184afc2afffc5569a63e477a5224387f6ab7f0cc"
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
