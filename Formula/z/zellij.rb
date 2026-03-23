class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "be413dc49d7bff1be6502a1998664b015b77ad55636d72e0497cfc66d4a4cdf6"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cbcca3b96b2fd6921131b268c6eda24d65ba0c8bedfccb3a46ef75b807fe6b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba199471fcabfc05ac8ba91846dd6d2104cd15889ed499a18f33ff066fa1a368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a837f3eb4f66086c0e8ec8abd82f4820c4afa7e8fc8a18477467e391e362dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7144e7bd3e50f4e03ae6336bcb4e7ecc533c1caf93e74695eb37837dd3c65e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f48f98f3159d6091eb7fc3c40bf912956feb3f1adf74fdea6e8f801ddacf1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1028ca00d14f72d262c84724cb3627e67908cefc25ccb0e9897c4269183b54e0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
