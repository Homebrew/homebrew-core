class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.56.0.tar.gz"
  sha256 "c8dc7927d3c27e9897398855013c5e4eb31a76ab45dd4aed7bcf5f0121375286"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f33d364998c47253473ca9787a99849e54b9f72779deead06f229e239ea10be"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f96acf71c8ee5779a50174f80542208b6f5d042bad0351f4a4fc0c5fd549d72"
    sha256 cellar: :any_skip_relocation, catalina:      "707a65b8899764156776798e36423999f336e2600068b029d1fcd1c023f2028c"
    sha256 cellar: :any_skip_relocation, mojave:        "ac230bccda241ad8a90d0bbf2f4c8ab76df3eb909b3c0aecad46b0db16405470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b0aafc7c6a3cbcf45d4147531cccd03ec70fe4d0deeef6295fb9e31239a33d"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args
    on_macos do
      args += ["-tags", "brew"]
    end
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
