class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.41.2.tar.gz"
  sha256 "12e7f0f80c1e39deed5638c4662fc070855cee0250a7eb1d76cefbeef8c2f376"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3985d14a2d7fc0c66ed878ed2c600f5cd238229f694c9087d011b6a82b289185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acb39aaf105fbd7512268fa99df97b1869752078aeb8f76c84a4d5e196716738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f7515d90e07423228cdc194e31352d808dae128ed5daa982bb8b570c14bd0ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "515bd15cac534bd20f41aa2ebc77c45646e2dd8bc1a8c41ef307e89988b52b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "0535d3328feca430ce40127148a36b13510d993f0f34977700edac74c136485b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3bf727ff5681b0f7a4b83173f259f7b34f6d95bccbc4d41669c481d3652800"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
