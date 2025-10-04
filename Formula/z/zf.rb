class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.3.tar.gz"
  sha256 "ae8f088dd25a10406e8f7a27d9ddc555d28d746950fd653f4cfe42ab0b903f58"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f605e11345ec11c1b7a06ddb36aed7d62aed6de226427816760b5852f2d432ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f697369a780a2b658a20061d85844fabedd36c4473a4b6898c7081399cc8339f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33bb84c18c4c908e3e1940c6ec5206eda1e840dce602b18d1f6d01fe69ffa206"
    sha256 cellar: :any_skip_relocation, sonoma:        "460904b2df3f8cebf62efe86e5d9092a10f398837e22a40083fc63d54fd8211a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0c7534938199aea466bb7bc65e52a3504a01c76126d675daeb0ca1fb564be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28fadb3d696d45a2c3f1656a5a7e45ecb60054f3a201a6188e33762e1c5a562e"
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
