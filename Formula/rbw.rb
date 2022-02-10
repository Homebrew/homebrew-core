class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.4.2.tar.gz"
  sha256 "0670c24f835b7773a317be33a20ce1c54861528983f08c75c7313c02c1e3bbf9"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6c6956ec60f9b308eebedc096d0914b237944bc3205d00fad76122b612eb774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75f11e7f8410cf22253cd3f96e478e07aac17f1beb629666e2c93b969a923780"
    sha256 cellar: :any_skip_relocation, monterey:       "44726d5d7a3c5025ad4e01c4fbc43389cb4fef1de0f7ab476d26ba05cc833395"
    sha256 cellar: :any_skip_relocation, big_sur:        "617806ad5eb8c1e751e478122e309b685b99105ef7035136a747bab5bd847fa3"
    sha256 cellar: :any_skip_relocation, catalina:       "9742cbc7301d8c7e688329a972f35c8e942ba0cf6540930fa25268de8cc5ea02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c53c86695d45773aa92d7409b41e0d1c4bd5fedf7813a17dc52d5145b0dd58"
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
