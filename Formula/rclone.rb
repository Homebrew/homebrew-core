class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.58.0.tar.gz"
  sha256 "b3f953a282964d6d73a7278ccb2bb836d9aca855e9dc5fb6f4bc986b0e5656fa"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04eeeecb70e71dd8aa158583a2cb99425aa63f4b97b52ee37c8935b44a22f629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e614f93f450eb131e3a00224bd8f50d47ed78615898e8c8cc57d985c4812d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7995baae1bea1c49c6ee3dd4d6d36bf5c10e690517918dd815624c31fbae3148"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce295e808e5c51d57c2c6adbb705b9a76eb621ab06201d16719504487749efe"
    sha256 cellar: :any_skip_relocation, catalina:       "d52c7f71e55be9960ed4230f85759fd0fc83a9c961a7f30af2c89ee48ad0023b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75cde9ff91f67ce204820ec193a84b07427bb91a8a2f54f76017589b3a9f0ffe"
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
