class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "33ae61fc802b59462fed49b424893596d3aa819646bdce53d5602f714c1264fe"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6decd7dfb3879e42c52a9eec138c33dfa9c0d69c9ab51896be876ea950bb323c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29132e50ca246096e5e6f0144423131242d88783526a3fd3b64d672db87be6b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a728dee27e4fe97fb579d975d1ae3d8c288ce02f75461e5536e2105e79b4a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f2f83a458132c06664dfb68b171271cec4720cac3cad3378e7cd0d4ac0a491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8747da68e69c9a69936e18555de5681aa0ef9311d6449e6bee112d1f590c7590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d07c9a26b372b8de218ee43a4b4dd4b83412d70988d3242f4739426ec471c24"
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
