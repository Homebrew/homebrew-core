class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.69.2.tar.gz"
  sha256 "46507a8314742255c8949f3ee7ab57c0cb2cab0b01065c9a4ad7b28da1fb54ae"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82f4e4d39d340a0bdef40ea3cd877f47796c525ece174a6741cbe1b3f109a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d7c69483dfdf17c6708a24691438332c371542c95c431044939b25c6f0ac6fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcfd601b86a54373cdf2df4b260b0d51a72743c90cf87a1317b75088ea38687d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8de0f38dffc797fe54ac73863913f43d1e53320d942dbd9390b07c94d880b190"
    sha256 cellar: :any_skip_relocation, ventura:       "4c7acd8802b7b1333a5bd6d5f9def9f596dce3cf331174af0cd6860cd05ed180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d28bc874aa3327102820de53b6444b9552cb385e0e01a1995a1721a9fe3f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e6453bb5cc2b2218a80806e35d129b0cf43171bfe74c02461bb3ae4b55f6e2"
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
