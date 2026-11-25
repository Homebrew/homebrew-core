class Sqlmux < Formula
  desc "Terminal database client with tmux-style panes and Vim keybindings"
  homepage "https://github.com/kackerx/sqlmux"
  url "https://github.com/kackerx/sqlmux/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "6bb10b989633f56654a58a4cb8e89f2fc48121c7edc55c75acf8239b1072d43a"
  license "MIT"
  head "https://github.com/kackerx/sqlmux.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4c79b0806d61803720da54d7c732d2d7391797b36103dbbc5be0ad015c2c17d0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5427f0addf3544ce4fd567b8d4c6e8506aa0581b9679c24fcf743506ec380a32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ca2c345a05e69691ba86b4e55e3d87b676f417b0a9569e475e7aa804d0b59c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efaff20f137995ac1c7c6333dcfd8688df5bfaf060d79e9f2d72bb26566bf25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8441c2d46150f7fc93d432acb915e91666308c3113bd9c3c2ff7b78f91a530f6"
    sha256 cellar: :any,                 x86_64_linux:      "46002d8849e05d88f3aa56dbed122533d4bd80464eb5f12699d80f85b1231840"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/sqlmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlmux --version")

    output = shell_output("#{bin}/sqlmux --where 'id = 1' 2>&1", 1)
    assert_match "--where needs --table", output
  end
end
