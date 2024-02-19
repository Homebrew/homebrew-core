class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.9.1.tar.gz"
  sha256 "93c29cebde61ab75014fae7dd2ff218a0b5c769ba86640f20a0d7fac25edf993"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f67612f23ffb1a33f2bac3bc948e2ee3eaef617920f7bd5c228cf8fbf8dfbde3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436703a73ef1a81f8e6b3895534cbac25ffca84e67c2cb2a0fdbe4e8450d26be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1a6133393771f7ae18606280f037a081bfef63e071ac05673d84b7a1a13432"
    sha256 cellar: :any_skip_relocation, sonoma:         "a063457f461b1374916cb101139d0507cdfabe597817f7dec07d31d30aa6025a"
    sha256 cellar: :any_skip_relocation, ventura:        "2d321fedc50de2b33f595003d8cecadeaf3f972b214a6f673edcfae72d27391c"
    sha256 cellar: :any_skip_relocation, monterey:       "eefde17eae947cfe908b4832606f2987d5eb95cf4246f4e59a3d713c9f6157df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfdbd78a226afb851913b45ee6eb2263c856b575de430e1bd58edf874581c8ea"
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
