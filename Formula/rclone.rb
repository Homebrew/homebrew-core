class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.3.tar.gz"
  sha256 "46fb317057ada21add1fa683a004e1ad5b2a1523c381f59b40ed1b18f2856ad0"
  license "MIT"
  revision 1
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "932c69d40360abe58bd2fc91db3ee38112058d2f447a527ffa84c95ba0135637" => :big_sur
    sha256 "4e8eef33e6affb52e81c9d75b7c9ee7f32ae30e1bb6ceb9e46f697c8251dc145" => :catalina
    sha256 "6a33202f0e09d695e130694f36c7b7a1c4137f884c8da5eff80e737f8b061c7d" => :mojave
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
