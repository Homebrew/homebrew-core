class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.12.1.tar.gz"
  sha256 "c564484f1054a85014b6b2a1fbade24d56b1b221dbac681c682ffaeba158b697"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf58edcb974c14024158cd6717c2de3e9b4c7faff3c9a753524da0a577cdba3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2930df93c82e9803324ac4af1ebf8327eddbac674d3d4606321d27d9b006b0c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3286046b7802ae7b9104fde56bd5f37c5c57cc96b22075baedc7bcfc2c312b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f218ed659ec9155aa9d614917786365a5f052a3f8a68a902bb57c468ba300f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "08977594fcba3088250ece14efd9b348ad2731f0337c5ad531cecf47b99e71ab"
    sha256 cellar: :any_skip_relocation, ventura:        "888778c497c7823faf7ee952eff994d263ebb5c45bf96f0209037cd5d69911a0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b30aedb03ad04e5d792adcf3151fd9e7c3f2f779da6e66fcb16c3592d546776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4463edf9cdf55b007acef78cb394d01d49dfa592216c7885cf7a27e06b19ae48"
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
