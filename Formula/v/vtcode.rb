class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.112.0.crate"
  sha256 "8f54f1144f0da3f654d52100f3e2eefc875649db3873587707f8ded4ce60ad18"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c29c478def50684561240d8141e0d4150d1839b7ed28925a444634d93600b4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f591c14fa5ee28ee131380cf159bf8dbde1f7385575dfc0914d582a2c43f65c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cccec090b3f0b574aaf4a0f6cd786910ac8c2cc657e03da5187563292039326"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b5e695a64deeadba2949b391b2026dad062cf5895f5bb5394d655d906b82d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9cb62d5909d1cc597496a2644d6d84bf42a34f70622d70e0dfd4a7a285b9406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7933451cac5277e41c1d602e13c131c867d243458ebca8af51e059732650c4f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
