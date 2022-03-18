class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.58.0.tar.gz"
  sha256 "b3f953a282964d6d73a7278ccb2bb836d9aca855e9dc5fb6f4bc986b0e5656fa"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dea3f371a26f95632b961cd76ea814e0c23aceb4921e2878cdbe8161b73a924a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30daa088932296311cce7c4cf081318aa4058f3b112c28503a2b7e532ec78dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3ea62f9c0c08a828671d305e88ee19aaf49b0c0456e1d63066c2fba592306b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e91e118b3c97dd6c620751956b7b3cd1adf45ffa1467469e24033d286c360a0d"
    sha256 cellar: :any_skip_relocation, catalina:       "abd890852b01a94e943c98a4375642c332508e6ab011d93318623a09bb67df60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471de3a5f330b651047e3fceeee65e8367760f6777156a45b31a6cf6313c5954"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    system bin/"rclone", "genautocomplete", "fish", "rclone.fish"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
    fish_completion.install "rclone.fish"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
