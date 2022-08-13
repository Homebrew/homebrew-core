class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.59.1.tar.gz"
  sha256 "3eb56502c49ffe53da0360b66d5c9ee6147433f1a9b0238686c1743855cc891f"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8cf584e3209e1cb9f0b8255d5f4beb757bf33c36309922ecb6dbe12f7349a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4fd3b909dd1e43ea20fcd793377682b1fac3e7e534fac8239344d89b677b9ec"
    sha256 cellar: :any_skip_relocation, monterey:       "f42d1176d97e2efa857cec91012a6f907f0a43bc70c008659cc9ff46ffcc0f29"
    sha256 cellar: :any_skip_relocation, big_sur:        "e368187e45a3d1917bef2c6e813af7f49bc8bd6bdb09ce8f929e15bfbe0e9549"
    sha256 cellar: :any_skip_relocation, catalina:       "738c7c235d83340ba6688804252ae15ad894364ca496f448cec37e379e4ac9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d1addddac369c444119d390c13be27f93e7476e5a8ca9bf9ebea5855f81adf7"
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
