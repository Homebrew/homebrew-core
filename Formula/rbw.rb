class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.3.0.tar.gz"
  sha256 "7255e322b8c6bd6ee9da00f4c54211e94a132abec15b9f51b8351af31a4744ac"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c87111e66d9c3588238918493fcff608885ffe3ab7a17d8af7e34f5d44eaca50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0ba9f71889ea47c3a6b12df6723ed378b2a35be281d3badb4e7a87ac81e057"
    sha256 cellar: :any_skip_relocation, monterey:       "59299d69cdf5cb461d0802eb7725a2d6db58dac534337bb54612a8e7833c59c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "916a7562c8c63eb6da7745f1698a7a685bc8d56478f98793f9c7a1e05e35f4de"
    sha256 cellar: :any_skip_relocation, catalina:       "dc4ef8419b27659d6d6b937bf21c2357b3fdea7ca0befb7060c224f8f7f36835"
    sha256 cellar: :any_skip_relocation, mojave:         "762e2ee5b53c5c64c02d0be5bbc248d84b187e4e641c2aca4d19e7517f71ea2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd02ace12c281792045f496308cb037003e3727f2c79d1f984de7a77b882bc66"
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
