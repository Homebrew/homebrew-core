class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.140.0.crate"
  sha256 "cc1c94c21924325af7cf13ddac00bf95ae71ec95f9abf6034a60d87389b1d848"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2389c33591c5b997d0e7ecb342df3ef9b0feda22cf5e5b58e92771b6eada8005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f6cd2dfc33b079506e8d83d66f73c114707244a30f3531cbd181d6a6ccaff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9567338dace6482626ba2569200210eda044e889aea4af321c3bbfd60b96373"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8f3302c399d13784f5b6e6d9b48c7770da738f7392e1d5144b94bfd5ca4536"
    sha256 cellar: :any,                 arm64_linux:   "4d779b54195a84299984c7163b04379d34156f1eecfffc1ba2bea9a671863106"
    sha256 cellar: :any,                 x86_64_linux:  "8b1f882b4b741ad5664b92f2771ad107c6eadaf23fbbf54939185d61191c12fd"
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
