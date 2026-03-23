class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.4.tar.gz"
  sha256 "109995116dc1161619e73c12806f5d168441cf5cf96aa6bb780939d10ffce978"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac2fe7a87e09b282b70acd1b187e5a85587d99710a20dc8a50d9ad2e38cc414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4148ee65a03d4c7e47ab824ada9a74444e22d58829ab1a65ab18efdf1b9ecdaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32a3deabe78d371b935487e971edeba309f35bdd8cf2a3e1f0d4907f3527f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f56384c11eaceb0d1bd00a89716a657c5064f75517e81fa714813012831e39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "826e630d1965ab55172691f92fa524dcb0969e0b0e2a1398754a5a41836800ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035ab9aebe146b56a3c40e46c1fa39aba039a22db37d5c57e4e25f3737940fe1"
  end

  depends_on "zig" => :build

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
