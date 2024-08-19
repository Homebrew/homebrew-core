class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.2.0.tar.gz"
  sha256 "e3950b5786fc2953d89dccdec29f1092eeab2f0758bdd582229aab4cf5cb4144"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebfea5fd615ebd80aba562e43bf9d79da826a935fdb21b18bd755feda9428af7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e213f76e5301f29ed49f66e0902519e0db8ae8e523374181f9a81cc63c66d31f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3548c66051614ea6bee7bb4ba89a8c9d18ac469941727b7b700926a35607d74"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ba6b7493b84f230c31cb3b9c79a06c16e11d23cf5f1deb95258ebbbaf4f63c8"
    sha256 cellar: :any_skip_relocation, ventura:        "a807f01ad19201fd0caa3cbb63bbaa7b627614af443730816fbb8a8262c8f2a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9ddd23cf6c06c2457ce0d932359717e67f624ef7d25a3cb8233e7e249e558617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02d57870f2b0fb0181b6f1ff933856924f5770093e63add60f682dbae1128ec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
