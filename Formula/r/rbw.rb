class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.9.0.tar.gz"
  sha256 "fdf2942b3b9717e5923ac9b8f2b2cece0c1e47713292ea501af9709398efbacd"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e8c07f8654dea12309ea16bbb599da2e5b34791b890a3aa54e5c79ce9eeccfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77e94c72240c5940989c886e7729f4e34088c09b9079671ff389096f1588d102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055778daeb830359c5f3faee7e0a8e9c0092719202ecf830ac432b5ef34c6640"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcee4584e54e2827ad95d6c5e755bd870a84898cdbdfd3bf9854a6f6d7b64319"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e8eda5c30dcac172debf852f30a5132a51f22a60841dc962bd65edc3e1a5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6e26e833209f194f6506d125641db4916838884d14e9ef3a2c882f36e0f1b96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a10cad8a4f74dbc68bb6b1ccf861dd8711d9eaa2152c1219a3cc5dc7e7945a6"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
