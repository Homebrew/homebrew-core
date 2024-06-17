class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.10.2.tar.gz"
  sha256 "e0e4da2b95dc6f141e0597340e535c61224716b2a7220dce5418555d18e672c2"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0f465751b8fe70c2329db7bb93a06a21dc9b1578c8ab45c639468a9a1336c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6068c72c19a8cd08d6c95072187bae681c8aea04ccc9a5b4bf125fab4d62d8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63cad3802bee7108de01f6094f2eb5efcd8fba895ceb522a4291cae4d788ae16"
    sha256 cellar: :any_skip_relocation, sonoma:         "67a8bb7a1355a057907159873a4af28261f81a4ff931350ae8d86f36e121c47f"
    sha256 cellar: :any_skip_relocation, ventura:        "8e3ea48ed17954f028c8c60d47bd75131e3cd06d23f368a9287e9b33ac4f1434"
    sha256 cellar: :any_skip_relocation, monterey:       "9ddc5593162a4505e9c130ca552ca43b9ae0e2c95ead536c65964c1e3102e463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578cbb91fae4b0c4ea458646215e7396485dbf86eed61f40ea955d688b249704"
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
