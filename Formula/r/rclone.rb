class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.64.1.tar.gz"
  sha256 "c94ad2c2fa79485667aae4a239ed04e786bd6e26bced05f9d95dda6d10f7a014"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14883a374003628ba083cd62778d685a1508b096b4c8f0ea17df686379164b10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fc323c243885a3fbb0d8dac5bbd3ed9f00fe9c130ed024452844c356d970ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a74fc5aaf2ea30dfd0d264d1d01af6f346662f8937a31bcaf6f5ebdb7940d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cafea8642e80ac9381072d860285b559f734f1c20fd3eda4bc10dc7e51e572d"
    sha256 cellar: :any_skip_relocation, ventura:        "dc5c93c012443082248b560d49c8e448f720e785ddb2bee5353b3dd7a1e97a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "2658d2b0e077cc8f9000d2daa0dc27e9812c7d374de5b95d9eed8b4e64d00724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52600f9babdd4edf73f4aa931397c8a8b257aee1bdb1b62cf357b9fb8388d79"
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
