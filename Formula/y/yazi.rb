class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v25.2.7.tar.gz"
  sha256 "3d31e3d94387a92c072181e3d55dc15e23a2f81c1a2668d35448d7e5c70887ae"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba54da545d0115236664e029b3ae1d419afe51b056e66e29a3e1f5b05c8f05c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf5865c823c7b3ce10ff1d4736e0f53389f25752cdfa594f1dbf9dae3618d6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3247b4c5ef816299cac1f4136d6315d832b34f4d91c837d3ac508909a2d11639"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4ab2c77a3f8ec2223d7f23e75881ceceb244345cd2bba2a6138ce5eedf250e9"
    sha256 cellar: :any_skip_relocation, ventura:       "9b0b58d92279e841ad17061c8be648ff024abebc79c9b5f682a7f3258e2ee71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6031243911f37d5038d6efd4fa2c2e492aef7e630dd3ab154503593272f84156"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-boot/completions/yazi.bash" => "yazi"
    zsh_completion.install "yazi-boot/completions/_yazi"
    fish_completion.install "yazi-boot/completions/yazi.fish"

    bash_completion.install "yazi-cli/completions/ya.bash" => "ya"
    zsh_completion.install "yazi-cli/completions/_ya"
    fish_completion.install "yazi-cli/completions/ya.fish"
  end

  test do
    # yazi is a GUI application
    # new `yazi --version` output follows this structure: `Yazi <version> (Homebrew YYYY-MM-DD)`
    pattern = /^Yazi #{Regexp.escape(version)} \(Homebrew (\d{4}-\d{2}-\d{2})\)$/
    assert_match(pattern, shell_output("#{bin}/yazi --version").strip)
  end
end
