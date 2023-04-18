class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.62.2.tar.gz"
  sha256 "6741c81ae5b5cb48a04055f280f6e220ed4b35d26fe43f59510d0f7740044748"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7345e71d5ef09336ddb9d14fba834865f1e67383fd539fd23d15b390518d433d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd52c77a6c93776d3c00427c72ef9939a20852cc4e127f4b53217e99ececc77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de8521803b7339f2db26da43e01bea273232fef21a2355e5cadafa4c6ad937ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f19db43ea7842ec49358d2929b9b02a0a83a48899ec1cbcd7ef485a42d30c8f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ceffdeb0a1565ec24deec3b7caa40b4765bd1d5b39a9f672d02742f29af3afd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b30c50fb83cdcda00c3cd99f37f55c1b601777027f7e9e967f838fc486c804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460f2761041265100f86d3aee988af3452377e7092347270fb563cbda1dea085"
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
