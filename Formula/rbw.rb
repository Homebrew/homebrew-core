class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.4.3.tar.gz"
  sha256 "2738aa6e868bf16292fcad9c9a45c60fe310d2303d06aea7875788bacda9b15b"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ecd2fae3aa1f8c9a79e54b10374d2d3883cd2f7da6f80cb10c5b312a766b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0ad0d1f9b000d402207edd421dbd4a855e6ca2fc1ef38d0ac49cb0ddb6ea14b"
    sha256 cellar: :any_skip_relocation, monterey:       "06a9d7f7b124b71d004a28f2162279281b1ac9510d171257349df982a8b1c7f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "27916f0155a5abc5b4e649988a4b2c87162ebdf07dc2bc246696aaca0cdf2a07"
    sha256 cellar: :any_skip_relocation, catalina:       "be1da47f5a8b893c358cad317ae86538510838c023a9afb6c3d4abce34a8edb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edfd511d66167df5910476b102c00d5f3f24fcc299cdbf6cc6f3571305a8f870"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "bash")
    (bash_completion/"rbw").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "zsh")
    (zsh_completion/"_rbw").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "fish")
    (fish_completion/"rbw.fish").write fish_output
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
