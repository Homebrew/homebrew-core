class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.4.crate"
  sha256 "713f4716dd7cb36828f03ec4f12d5bbc720345230345907cc895a352e9fe8d35"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81b3cd00106dce58ff7c1eb1d501139140bbc297a5ff9cc567a03819086fdd80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89975f09649664cf4b65a87f3ffaf8bc009c32434b6acb64475498943d50b9e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac6bdccb5f3e9fab675505e4cdc5fad1f8c51b9be21e7efd2f9db2d491b2d5b0"
    sha256 cellar: :any,                 arm64_linux:       "dab99018328210d7cce6b00dbaa90ed2c873526d141453450c9ee96558f3c9dd"
    sha256 cellar: :any,                 x86_64_linux:      "3ae1decdb3ad66959c60e69e9fd6222f05b527d513b53c3ef7beb06e3bccfa20"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
