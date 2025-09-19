class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "20eab33e279e7c14a20174db43277de3f5bbdcd248103e014d6e54374b43224a"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508fbffc35d26e9d8b697fd07ce524c8ca12e69b54fbb4fa2ad331419e2bf7e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a1735c2bfe33c424a7c2202772564d64603f3be68019d0e419832570de86d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7250798fee96f9017525a2ec4a433f6594f14bb16699bf702790aec5bb7abeeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6d476e50575769d8457a1cf5ec52975a60f49927a1c8bc9afa00553fd7b086f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8846c9b8c21effca9a80c7f0a1e47b842d3a5f9431f90fe9aab512652658ecc8"
    sha256 cellar: :any_skip_relocation, ventura:       "e358fb30c7676c1e289912613e415c330e561ca1d649ee49a0a48a9415dfd7df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b839900ca9312d3a2967c25bb89218bf7a82ed29079537d5e874a71e644eed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bc01dbdbe1b62b106f9c2a0224e439f1751c4937c13be88eb5e0f0bbc90da5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rclone/rclone/fs.Version=v#{version}
    ]
    tags = "brew" if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:)
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
      Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
