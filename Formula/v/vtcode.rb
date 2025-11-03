class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.39.8.crate"
  sha256 "a2867133043597f64edd14a53cc3626e221379f4bd06c477b10f3cce3bb692d7"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdeb75bdfce2f82d19b65724a245235e2fe21a8a0e03fee3d5ce5090f0734f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7415b2501975b368467d28e97f588ca611fdfff81d5a4d552e521edc7f338a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7b78ce592173ccba9c275de74dd0f3bf4b4d5879019ba2f2ffabf41eb4fcc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ab595640090dc897cf813472e0a1a4de64d71494c209ec9da9f95ae9cf18b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c057f5f73f47eb1e082ee49a27322824eda0499067f585318dc4428c0af857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d2f8038fec91839fbadebdfea8c3d4e78187efd1b6c1155c45a7cecb21095e"
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
