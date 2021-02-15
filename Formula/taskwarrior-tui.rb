class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.1.tar.gz"
  sha256 "7443f8ff8e55aba22733419d306b0f04ea99f48b5bc48ee82e2d0cc4cbb5d96b"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c319ecd3c288de035f196557fde57d4a495c0baf63d702086e428580ce44d2e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c264ef8e091b05b9e07a9be3d87072cb77d0cd85fbfe9054c9db37c18e4d2be8"
    sha256 cellar: :any_skip_relocation, catalina:      "77fb0d412a769b36dd63eff3acaeb31d295089bc18b6d0135b9208ea8d534d7c"
    sha256 cellar: :any_skip_relocation, mojave:        "67d3369d30e08f6e5a67091b5549179502bb9bb295347ccfcefc6533c57ee3f6"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
