class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "main"

  stable do
    url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.2.tar.gz"
    sha256 "b8e41f942c7033536fd64f9edea467a7ff4f45d52885d585f0adafb7803ac0ed"

    # Backport support for Zig 0.14.0
    patch do
      url "https://github.com/natecraddock/zf/commit/ed99ca18b02dda052e20ba467e90b623c04690dd.patch?full_index=1"
      sha256 "00d1dc4f178fb30bb8cb1e29a517f66f5672e2024a3aaa9413f16dcb4cbdb1b1"
    end
    patch do
      url "https://github.com/natecraddock/zf/commit/03176fcf23fda543cc02a8675e92c1fe3b1ee2eb.patch?full_index=1"
      sha256 "0c3be877327fe3a2258d9f9c43fa2f6d310e5b65aa2ab35bcc9262f05242d552"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b7c05de35a1d57833aff7309fbe7f05d98ad80686ab6233906a5c5e458c9f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca18e30ed084337c77376f0af8b97d3f10bc3ccb20660f7d74c15644fbcae1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b45f360b6662b147c5adc50425ef87afac800c9aa2bdeab1f2f395614ab34b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63025c662d67807c0f75b4df08c26b5af01c2e602d5438e2a08289b7ce8bb350"
    sha256 cellar: :any_skip_relocation, sonoma:        "468b27e2ac00706f31f56fb7ca8fe5aebd31ffa282aae0b21eb8ec487a77561b"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c75c28e02b4c7cede59bcb1137c62cfd34801b9a06d11855f96f0080829756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bfaef19e583a5409511f21a9853c0c37d5ea0067782cce94a92ea791200c4b"
  end

  depends_on "zig@0.14" => :build

  def install
    # Undo version update from patch
    inreplace "build.zig.zon", '"0.10.3"', "\"#{version}\"" if build.stable?

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
