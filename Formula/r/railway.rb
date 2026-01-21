class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.26.0.tar.gz"
  sha256 "73816fa311638129b06f4f1afab520fcbedbbbd7217c339dc1012e688e160dd6"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ca969aa1f3e12098919826a5bfa30690b429313a5dff1a136930f09d63024c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5462ab6dd88752c7364361a99a196bd76762a62fe8615acc912cd11d4faa30b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ac98755918ca42ee5d2a331bc394f81e066d6f28b7f8f18332a790cbf03744"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e74a1e46a1eb77229cd35b29504cbfc6c5f87e4f0eb04e043c2f611fb254a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb2e64b823f16e62e958e6fb0498021661aac90b5ca299279f5ecab21de8c7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7841d23c6f89112809b5163ae0d04ee66fe271f8f633e4374ed7fc14150ff72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
