class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f28ebc279b530ef39b69e9a534011b90496160ee2839be10e33d2b676545105a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66b6561d1635a048ced64694b4e97f63a030216f3516e455bade398c3dd4b422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877e1d24bd63880c5246ebd23e49557b0523c5f5cafe81fcb4cc6b7200b835e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3036c83dd2ca31cd02f0fd298b7fc16a7389c71426a74aaa2f724ae4cd53e322"
    sha256 cellar: :any_skip_relocation, sonoma:        "164d79085b6d258b859cfd6accb5903f135e138005547b5d71238166e3f17714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94952735dfee052ea82927a74d30b3133ba69d6b5ee207678d48afe21f3a98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65fb0a111139f7b59794904d7b552996a83839c31b4f13defe274fa67ad9f363"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
