class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.3.10.tar.gz"
  sha256 "6db6ac7525f00c4a4cb45351b9a229e253b3e9053ab365d6f881c0144159f8da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d7e85273ba9610f58c2bd4b09dae43d26d14ca4fd05c70cb000333b772480c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c87613d940e55ad55840b4d4d0d5aa2ac0814e3842bbbf1e2cb4e73213def7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5da675d8d39eaaa590b65cc317ad1f0896d1742176d2e8873631984cdd4d6f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f06cfea66f3c4770f0994d157e4073af88f43e6756b96fecd281aef18a0c236"
    sha256 cellar: :any_skip_relocation, ventura:       "1ab76808760298b841530fcb9c94419ac7d39d2ac8ab665f2abf61d2f04fa2ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d8f3764b60da68f69d536114a5cbf23423e55837f9669d00ff17da67e826ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f227abf749a35a088e4b416159a682b5eddc5e156d2e49b46892a6aa394ef5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
