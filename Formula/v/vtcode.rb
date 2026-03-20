class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.91.0.crate"
  sha256 "96b213bb2b6eba4497e032e04f93eefba0aab2f9064f27bdcd19b30875904eaa"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aca26bb6c147ed1b6a5427be7ff99f6db4a9c510a3e88cb19f0a58e15c2712b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e628cc422a31f73d48af6beeb5653cd92afbaae1b8b10f176b91b5ef93603da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3368be3d28acaae41dd80f51fc296a49b45bdf07f31b417520020f6d612688b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b43a48a6171659ed3ad398450e1b216b3d25916368bcc32624aa6e103e6f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d077bcb19a8c4b329f1a27f6ad913f5929a1c06e8f591c77d761e612b99dcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81ac617e3a6562729354e2af7c29da282c20004a2a1dd5c12c14379cc2bd4c99"
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
