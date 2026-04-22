class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.100.0.crate"
  sha256 "bccc1f9d57fe56d2b8a106ba7bf435ff9ceb68487f6265ea7202161fd7847089"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d00a2ae66dc104bc83b4d3cc26f1421df89a80106519b4d1d6c10f75da6336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173a1cb7df5beaa3e25d7a44103fbe0cb43ca93cbacba232ee194271ea4152fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e94283e06eafc57297536610f017f3000385a4a7ffdd8b1427cef138ed7ef5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ee7bc68e9c14a6bba5546193a434906ca10276ba26c99ec492f93af400b1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e1f37387155ca82fe4f465eb56542b29496fa07cf9a5729b1a1ff988a4fe9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637b24707666d40ea46fb72c2d9fe39729d8f2ea09348c81b47136beb0e18a2d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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
