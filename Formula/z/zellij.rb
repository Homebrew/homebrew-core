class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "a7fb97e7d32c7be977cdc977d4f03a3b6bdb054251b3f2c36bf143671e4a7f08"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9288b99fd365a5abf0d6d83f71baf449974c86eaf17a651cd316f869b5a19e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6343c6b9405492e687c3c7c692a0c2754f58bcb14bb1961410918e0ac8b61c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ff5ea17de656fde4d4ca97d7ae6b80c41e980cb61cf0a739ec27320a97472cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "530992336fc50759d7aa848090bb7c14a39448c71213c1e3c7ab7322a8c4ed2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e565e015790a8882d3bca4b02be373fea016f1aec9bcb50f4515428c01478e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79bd39e4e379299c969f696723fbaf0fff60b48f924006f13144901ce6e813ee"
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
