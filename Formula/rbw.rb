class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.4.3.tar.gz"
  sha256 "2738aa6e868bf16292fcad9c9a45c60fe310d2303d06aea7875788bacda9b15b"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "734a05b148b385bec2e18310f7d4be169eb11e708aa69ccbb3f31ffa42ff4766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aadc7b1eec0744bb1f2cff7b9d0eb3d771bf5c4b6c9233d0565f690b934eab3c"
    sha256 cellar: :any_skip_relocation, monterey:       "4964be04458f6e338268ee0915bfd4bff912ca10f2f9f94895f8d42d2ac4ee81"
    sha256 cellar: :any_skip_relocation, big_sur:        "2014da4016670a7af9bc400201553843f6e3021281044068937af57e35d291f9"
    sha256 cellar: :any_skip_relocation, catalina:       "2650abf915c961c83d17026658e1df786b4e1cfcfc990388a561d33598195d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f59c9740672a539b333ae7790637500548a78f5c4dcfb9cc4b6a34c18c33de8"
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
