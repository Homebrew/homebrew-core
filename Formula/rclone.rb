class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.60.1.tar.gz"
  sha256 "b0037124c04fd1c31a1d9ae1c80e25555da3a22d7ab1ae714ed2c02247fbdac5"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c28b97ca6bfb8fabba52b19b79b6302c234b637408b3891a51119fc1f3bb9d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3e320cfa243d5571be800520d29be45e6b0f27a607717584f45ecb7520a5db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a97acb7f727ce780eeafca3e5821da67da5a05d7cb2c26ae576a43d45562245"
    sha256 cellar: :any_skip_relocation, ventura:        "ef288435f22866c44f6f7cc798a351d0d9caa1ccaf10038cfcd16dcdc7f8f60e"
    sha256 cellar: :any_skip_relocation, monterey:       "4731f8bbf4fc5a8036a67036563bd718014abaca19f59c77ff3dcb5696449397"
    sha256 cellar: :any_skip_relocation, big_sur:        "795fd26dbce15ca81768c7d45e8f79b7ef560f1a8f8f21ea7f5b8aee81c6884f"
    sha256 cellar: :any_skip_relocation, catalina:       "2a1926e28de34d656f81cc2fbc38ebe03992ce81f7ce7ee6b75669c0a7d854ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d326ef8f44922f6bd069fa0080629d9c9759814dd4ae52e30b401698cb8165ae"
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
