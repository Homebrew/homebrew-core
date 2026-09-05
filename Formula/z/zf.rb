class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.11.0.tar.gz"
  sha256 "6c990a8277d5ad16a5492bbb76fa2ace8ce8f4ecfc40ddf49b31d7ea5341d792"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff8a4ce0e60319c68384b126224e2a87aa8882e922906b2bc678362ca229c048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522ef5f018185a42effd62b867523ef7190d7ef18a829e1cba0fea412f3f7985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2070eed83a4b05019805cd9e152b7f6534eab01c1b7bbb5f5dfccc4d9d6bbb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e42df717fe829ca1875c31b94a9b72d45e43b99cffb2cb57f76e75656a177a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f026b84b2c3f6cb6e9e9a76f16fd56979ffe0d37ea43bd97db38db78cc96f90a"
  end

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    system "zig", "build", *std_zig_args

    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end
