class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.64.0.tar.gz"
  sha256 "3297838fdcf611a5ad605835f41c0e51031ce9f220c77a4ad0af6283b7805329"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b23a2685d61394eb2c497643e287514b6b17705870c2be8186b9af546fc4e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfe7fe25d71bda5479921306fbba8c84ab0ab34438d03352762133837440a6f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89426a7fcda9ed3a747ea99e7c49db0835a878dd29f60f79c1602a4f8f3f8582"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5976e83de95fa273c71e3d9215d0dd4394b567f8f08d93639243670e9e3871a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "879f7ca2b4c1362e3c48e33140f116e585602dc3f3b264248f547ca3840d59e9"
    sha256 cellar: :any_skip_relocation, ventura:        "bf826796d688550de5cbf99ac2612988b988bf3e71349a7f13469a334afbdd78"
    sha256 cellar: :any_skip_relocation, monterey:       "fc00d993ce2bd2784095223759cb03044bd6cd341f6595acb10f57af5a3d0b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "caaca84e91ac99e3f7526aa00d8ac19dfaef3e6466885fd434c3236afe481f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad18a64065bdb7673904c4835bfa694d939865364ddeb620e5f0827393b0d3c3"
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
