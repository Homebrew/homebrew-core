class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.146.10.crate"
  sha256 "51ff42fbacbe52ccb380847a70ce19d015965c64178dc133d606152618b1bf48"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f14c6366ae83a699e418d9db8f9ea6908294bf42520ef19f8c459baa8cf62d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b4ad5ec8df1bcdbb3fd17d1d8091edbfc78475e01e3ded5040b88ac6210599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a2b30d41b41e5c8c9c3213d38c33b71b39447cac4ff94dd26856f119d9deddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc21b232b1e2b41281fcaffd8f8bb69b12141c51dc85092f4f727f368829a1f8"
    sha256 cellar: :any,                 arm64_linux:   "e0bda1f83a658e964d597e7d76b20401ae48e3d611b20db9d62ced59e9073391"
    sha256 cellar: :any,                 x86_64_linux:  "d116f830b0ac3e534022f9c3f909541659a4767ff54221ed93a295ea1b73ce93"
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
