class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  # zf requires git submodules for dependencies until the Zig package manager is able
  # to resolve pure Zig dependencies, likely in Zig version 0.11.0
  url "https://github.com/natecraddock/zf.git",
      tag:      "0.8.0",
      revision: "fb66faf9258ebad06ac06c8d2a597b869b72069b"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dbab2a5e6182fc671cbbae1d066df3b5f08c4cb40c8ebde65fe9043e5d1dcf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d5a4a874a0bd082b3455fe06a16b0d4343b770a3701b248f211c24cb1d42a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aada6ce9c5e8d78dae76bd08d02a7aef5ca1ac22685c5fd65c29077dd7d87912"
    sha256 cellar: :any_skip_relocation, ventura:        "1c47cd203b641575113c6ab10b33608eb3b9495ff168d5a3253eced802760a4c"
    sha256 cellar: :any_skip_relocation, monterey:       "63035c6f21e1b357d347d0d3d92a790d4e66028911a3ee3b78192212eaea2fdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca285ce67e75edd1630b9db30d24ad2954a0749deda7a399114a5413a9d0bbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c26ef59e4187e32882b959a121453eb82b2aff3935a7f8961d642e5e027ef0a"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Drelease-fast=true"

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
