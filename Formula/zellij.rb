class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.35.0.tar.gz"
  sha256 "7141f6252f9f54127ffaeca6f2e3df1b9376c54ae8e1f3be39211982ea913336"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5441641d0d340f0bc3ad2a6fb1c64c13bade8e6a7586d4b9331cd53d0f26c74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b45bf371093febf1da924fe3a9d241733e3c128b5ebfc330787981ffe78d1d92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59267ce4d52a9dd39021048d39334aaf5919f6e94880b88a8227ccd9e698fea5"
    sha256 cellar: :any_skip_relocation, ventura:        "65fd10a1538a817dc2a9133264026c7dbde53e7d98340b3ed5833df05f1952a5"
    sha256 cellar: :any_skip_relocation, monterey:       "6dbd74c04d6c5161261f42105bfb13dd7512bcb815497b8029f35b8ed72c0eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e195e4b9db695160738bdaa6fc2ef565fd5c1bcf5fb87d852f1429a29cf005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66afab475ce488b82bfcd06116d6424ff98d97dd59d012832ee2b56ce83cea1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
