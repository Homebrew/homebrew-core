class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "e9fd24190869be6e9e8d731df2ccd0b3b1dd368ae9dbb9d620ec905b83e325ec"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd12578e1e52bbe7536fe7e2c57914fcad0cf935b6af381a4d6de6248ba8268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d0e7a93b03bf99864e5a2b753852d1a987a264d8cd98947906d6799901aa33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7843d66a1a76ee969adfafab713595d57fb671acc82cb7c7c4d85e47166abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f3a794db4ce52ed3d1e64d0a86dcf78e77f50e01ed19bf99193c373f46d563b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6f112c98a503e8d7a9bcfe22b065f2f036fcf829bfe49d77e5aa7d25f5fddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe90ea20c44eecc63bc7f412a3fa621d7e1320c4d508ed11a177fc6b2b04b998"
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
