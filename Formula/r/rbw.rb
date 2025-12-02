class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.14.1.tar.gz"
  sha256 "c551ec4665d26f6282ba6a5f46c71df79304f8c618a836c653f0289ff3ebb94e"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7e1cd33573f54c217afd705b15c390b4a283813ef8dd93e9d04113723e459d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b997b5495689cd78f982d0ae7de1742826d9325559109835762596fdfb291ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc2b2e7c89148fabea1ff21ac0d3ebeec513566fc96695549deb3f884257069"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b093d1587b76d59d6ca4176509d67385e01d8b0236a3f778750a087b83f096ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "271d357165a4213e02d8677b9800d204e840227367e0d40b9754ddf49516588b"
    sha256 cellar: :any_skip_relocation, ventura:       "094fa49181670ec1cccec404ac7ca6aa67a53751f22190e77c34a40126df7b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1dd4dda0101fe2140eff61d68852fafe55d0e5f38d6e9e8096ae9f9d774f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7c4573d8a2dc56302c8ceef98b969dd2cb844ad4ba053b83e681a36d087233"
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
