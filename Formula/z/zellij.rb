class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "feef552f06898fe06df00f9a590b862607266c087e804fffb638d2c46d9edad1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2634c76133e8e12143a0e30a46610d3de81dde8f9d23aba7b1f44a8613ab5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e39857c3968ad556def2cd4de0c9bc732978ab0006f4c5c07ff749dea5eb5d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b37c597ab271971ba2600e3892fd896759345e7cbf39110d9cbce01a42b836f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c682612593272ff3147406bc0924b3153019bf8d8cf777bbbcee36259c8f767c"
    sha256 cellar: :any_skip_relocation, ventura:        "aa86ed73e8c8549370cb8131c4bf206cdca03661164d798bde0c7e2bf735cd06"
    sha256 cellar: :any_skip_relocation, monterey:       "b52494b5256749bb097934d89ef7c193b7989f9ef641b41353ddddfd327b6bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589ab806622fc32568d563128e5d35ae206b95c31802e26ee26d220765828cae"
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
