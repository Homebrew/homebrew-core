class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.9.0.tar.gz"
  sha256 "a40caf5b9ed2c45a703b10d214f513cfc004489330db8202d3834ba9c824ee92"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4120665cb9bca22713747580d48adfb657b2806b726db52e3a998a1b4ef9661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c36bf7a7ed944c0d80f33e80794b905d4edf32137968e0ab4bb7d64b33fbeac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2234c6a28d19a665fb20869031a8efa9c0a94ec89a04877e748c2ad3db09eb6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "467734f42aa2fd4a220717b198a729efe5adf4149572d7ec9b4276394250996a"
    sha256 cellar: :any_skip_relocation, ventura:        "c3d84f9460b8f04d9d7b2b622526af330b0d493dd1227c13fd80dfebe647cfd5"
    sha256 cellar: :any_skip_relocation, monterey:       "97c640328830932d24b249dc56d456ef77b91cb660351a05c1f3d90447196229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034f08d75c4136d806ef51fa32e45a09b3fe4e1d7485023e2760283f75dbdbeb"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe"

    bin.install "zig-out/bin/zf"
    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end
