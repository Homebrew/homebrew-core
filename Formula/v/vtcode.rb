class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.81.0.crate"
  sha256 "0f5340edcac5e3b01f8dd47c6663b0fa1fa68ee995db5eb78045c82f071045eb"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29fc09e7eed921163417b73ca948b8e28158584cbacc5d9346e1bb83c68c3691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39aab580a513aa794f4a30af6ff1a1eee2095c9c09f49bcf4f1bd5f0c082eee7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93840ee95d29dc56b0b1f2299e81a2a002b973d0ca8bafe2556be93cea05b86c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fffb773ac591cef792bd5341861176da98de2494c9f3e8c555771592cb16dc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db6696f305370360bb474ded2f442b064e6cf71728df778cf7cb99f3a7b85cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c392fd85d840b13a6f2fc0d4ea2c444492cd1b0b10d854666355b2cd2e4a403c"
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
