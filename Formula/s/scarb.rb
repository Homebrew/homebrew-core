class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "d9c3d2b4d688fd6035f689b556e4fe5e176d3e882fb45108dac117206be7160f"
  license "MIT"
  revision 1
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca87ff06d621f25233fc9cd7cbf2bce17112afb5f82c66cba8cb57beed74c308"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd85a5aa060cbc156980e926f0206bc2aa75a52503805b5174ed97d5b1d250a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1db8a2e97e60eae99b1e053a3439dc1f232b70973d61dd01b0cc759377008f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d593db757aa9760d29bcdedda95bd92576c024a8ffe518db6187fd53c55e09"
    sha256 cellar: :any_skip_relocation, ventura:        "53bd28eab5aea1230433d142c398e978411e9c121ca2977d9bf329764829db4c"
    sha256 cellar: :any_skip_relocation, monterey:       "d4e7fbf863b17e499319500be58ae9a0ad3b90e819db09b00bfedd06185f66a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "562935619a7d655f505369681a61d9a1b3cbe036dc02a686d5ccc21f8e0b3451"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
