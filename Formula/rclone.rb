class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.62.1.tar.gz"
  sha256 "ce3b51edda9d0a476d9abc276ac6a374c7d6ba8be22caa8e33845797e6fc4f98"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1a54821575fd2d584f8746dcdb117a58a0cab38846c5ad1d5dc450a06b119c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56734fe3e9d2fc1952a5625395690911b636bc8beaf5fbd67660e1a21873fd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "346fe638048597560d50344d767d657104613cdb5795fed234aebf3e31a6176c"
    sha256 cellar: :any_skip_relocation, ventura:        "22cc2ad15194ebba7ec566e81918660adda45e7ae8d0362f2db96db988329262"
    sha256 cellar: :any_skip_relocation, monterey:       "1c43945f9db763a6c55ade9b4c43614725db229534035041ec2c72f59f49a561"
    sha256 cellar: :any_skip_relocation, big_sur:        "387e01fe85fb3a78d8eb5f0aabee5a1fb69d4e8aef8cf977b2bc5198bc857fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02083161e1cfcf15e62c3dfa95f09f168b7047e9e79555cd9ac3c3a30a9feea5"
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
