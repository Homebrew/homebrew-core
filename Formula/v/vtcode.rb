class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.98.0.crate"
  sha256 "90dc7481b1d339678418e5c5f00303e524db3abcfc6d21a67714a577eafad48e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d9a2839dfec162acfe98bb7f5165762b62f6fc8c4f9bc8f146d4abcfcc88605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ded9fe482006486a170bc185eaaf2cd836e79b7568b143e1556ed11c636cecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1502ed7a20cb53438ab18a80e500ee2f4ed205b1837fb5d086b0f60b7aa18526"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa60f5ccb3544436be724ea0ec6da8ab9b97e392274abeff0732f5826be65ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "883b3d3ccc1fc0b478206ecf05adf9accef6b2889694686a52ff76829f19b834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407280995cf3b219e32fe15d97bbafef78892816e1e17607e499282f8b314a2e"
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
