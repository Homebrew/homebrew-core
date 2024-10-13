class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "76f053e2e3c9e71b8106e3fc3c18fd4400a98c09a8cde5972305e0eeaecc08d3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "95b9c1b9d475343ea287691b05b797c72402d77df83b6e3337777874e4737d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2b2901f32b3544122323c26da892e08f87823454f705cce01d14d232476fdfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3afa62a7d9b37f1cc56aeb18eccdddb7aab80f02a29bd25c549ebd45238b6257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c0710b58e19d0ed0ca8bfba08e702edaa52c133127485de4b9fd5bb5f07e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "3abc297d8fe7d9408808eebd2e06d7a915072bd58b8945d5a19bd5ee9220aa72"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec417f8de4e491903ff7c5cb9283f32577a6984259b1ff2d828121492cf5ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "24252080f7e54af6aa0f953f65701677b12478c1936764cb8862751e83bd5c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd9e4bead169a07fa797b7a9025c50abbd881ff0f0aa95d5be400ed41fecb9b"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
