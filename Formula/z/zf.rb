class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.2.tar.gz"
  sha256 "b8e41f942c7033536fd64f9edea467a7ff4f45d52885d585f0adafb7803ac0ed"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca18e30ed084337c77376f0af8b97d3f10bc3ccb20660f7d74c15644fbcae1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b45f360b6662b147c5adc50425ef87afac800c9aa2bdeab1f2f395614ab34b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63025c662d67807c0f75b4df08c26b5af01c2e602d5438e2a08289b7ce8bb350"
    sha256 cellar: :any_skip_relocation, sonoma:        "468b27e2ac00706f31f56fb7ca8fe5aebd31ffa282aae0b21eb8ec487a77561b"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c75c28e02b4c7cede59bcb1137c62cfd34801b9a06d11855f96f0080829756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bfaef19e583a5409511f21a9853c0c37d5ea0067782cce94a92ea791200c4b"
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
