class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "ff15b85f0413fdf8c7f3c67b89c1662b2772b84e9f17af9a3e937469af272a56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63eebf4042779306242c1b9b89ef5c3b242fa8dcf602e6ba1b3321c503b5a971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08c87353390c2ddac6c8767429d8b73f32c6daa6659409ef9b2f74426cfba7ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e36023b3c4a9001035b1459288af375d837b8474a6d7f763f444a38ad0a153f"
    sha256 cellar: :any_skip_relocation, ventura:        "391162138581f6687cb9dae8f3d39242b44b08304b1a1c2b171e8af23e262b35"
    sha256 cellar: :any_skip_relocation, monterey:       "5786d67433671430efe7fc9d7ad29d4fd4c0f92f28d3ab8ffa053f7c8cf4de0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc58411ca7d3e3f50f0690516a933d8f8bd55747ad564e95ed22d422424bae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd32d84d9a954c03c3737f676d42c0302e202a9a36ad0edffcd1752c1b8f0320"
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
