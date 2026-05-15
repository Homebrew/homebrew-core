class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.105.5.crate"
  sha256 "2ca4dd496929ee96a06780a099f73ff2f7f0c752bfdb68610c232aaced1997f5"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d8231eb005b0d3f46b7e0d2bbf6a351e45f00347d05e1160dcca27257d64645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dedc185ec5934d7aa7c37b1af0f1211f97a2965c0ef92d5c43c3eed0006a2b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca1858981bdd0395a51ed7f9ef8d8f23ded5b5f00092da0827985a6b7bf795f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e32f72e068a1f69db6bfe7580d1d8dc5d143ce2450ed7ab03ff61e034da31429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff288be5159caa7d0db9b2d78e87f455298d3224c89649c8e3fda9ec803c697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66a9019daafe456880167c954c261721c15cf1cba067634a3d2c69f6c74dc19d"
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
