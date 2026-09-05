class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.156.0.crate"
  sha256 "95bae403d8208eb48f4b19c7eadbad81b6a20a78c6ba4784e5b8c149368f8d39"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d267f5418ef6695888edfd017cac0532dd80b4738cb76618f4c487b48375a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d82b5f28c74b2ea82e9dfb31a8614dfd5c585d76160616b3a0c09bfdcdaf1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f8196db3f0cb5fed39ba8683a55d0c93455b598d0820fb82fb0f00bc339cae"
    sha256 cellar: :any,                 arm64_linux:   "6792128a6516678517bc98d577c7ca84a79d3365a70c4a86cdd66132eaeb455b"
    sha256 cellar: :any,                 x86_64_linux:  "77ba834e4e1226a32aa3c71bbcf0835b272050317a341cf4d37109b2798b80fd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
