class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.61.1.tar.gz"
  sha256 "f9fb7bae1f19896351db64e3713b67bfd151c49b2b28e6c6233adf67dbc2c899"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d3b7afef89127b11234e54287e90e12fa144c636c409f242e6461fe43ee2a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290a30578392997e27355989f559a1622a457718077ca03e54cb94b32cd03b01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da1f2a8bee0493a00289a0ce67205e811fde3720373e842ceb8c2325b28edef"
    sha256 cellar: :any_skip_relocation, ventura:        "30f005d9f470a2c5ed58a735983ce62098f806522b8bcb75e77b093f5e1ca924"
    sha256 cellar: :any_skip_relocation, monterey:       "d76d697a235c751eda7a6169ace2c92e7f9bbcce522bd0a42612b9438479a558"
    sha256 cellar: :any_skip_relocation, big_sur:        "270a0678ccf8a9f3adacc9cab240dd349e8c06b70c0140b279c6d49449be1224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42c00e42a6efb48e48473f0170638f19cac8685da1e10a67770d4a596dc8cd7"
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
