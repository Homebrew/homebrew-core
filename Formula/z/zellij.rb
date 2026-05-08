class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "8a4c1558135e4dc7375fce8db3524c60289fa5eb5877068fcdeed9650140964d"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bed129ddda3761e446ca1670296fd7e6ddf984a95e6169726e9aafd38ec24e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a61ff20c8f7d09193e65340962b0298a7006f1e6abb1cb1dfb71081e95e2791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c974dac0ff1ccaea9c650fbe47dd07cda52342f5794856e3ecfe04de8e6df6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a376bcc6afe79d50f88f655a71b31f9af8f1ff1a8f96737f89f12a009630d6bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a086a70600aa7e6b93741bce09a25ed835ce56e6df48805ffdc405c907af8b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3c8391edac32bfa938fc4d2415d07cb5cc15ba56147a8a5cfa34ea68b9ef2b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
