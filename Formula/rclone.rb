class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.62.0.tar.gz"
  sha256 "7183c0bcce9688cb2e6c2b0acd4e6f69efbcbeaeadf6363d9d0c1479351cca1e"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39aa9a49dbcf777b222d6788d523360e722207d1718df2d337d898f4b9f77f77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1c1ea68a70a5656a38761cbc4451b03d1b11c2911f3fb437849c62cc2c966a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a950e4afd1a24be127ad5564b5dbac78c7b30cce914126d84daed53f39a0208"
    sha256 cellar: :any_skip_relocation, ventura:        "a345442933a5fab254b9d88e22b089b235f424081c01b14507a8d76485703a24"
    sha256 cellar: :any_skip_relocation, monterey:       "63ab348c632ef73ecaa5b2900ee2daad7112908fa42b003d2db922f5a8600c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84ae0f2a2cf4a3cc32d6520345a0d64e9c3356762bf54750c519e12541b56ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c37061cdd269636ef1012527f1d707075e98b2800b894297b2ab06f7ce23b8"
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
