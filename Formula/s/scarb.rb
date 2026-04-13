class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "65a588fec4202f6e3f5722fa1adb2fa78f1f36ead18e4dda60ce3fab9b230671"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee4355691368b6e10d2b03e918fc531bc89b0dab793d1db79c84d4d9e507741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712fc155ac5e563ec244bcbced033734b44de6dc6f4706e4c71a2de15e08f182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ce3814f5d0f743902635c4cea15a6d90cc572e990698fc3b2de1562fc13692"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b82918f27b0994fbeb1ed395a3b5d9823300ced11c1d1998ed54239d321fc71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128f485f9e125a8e23ab4991dc8ad242c5d84ed8d8aad24ed2d888e2dceadc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e747a63e202fc3874037d5772d198aec9879834403788a6cd5003d5ca6ef2f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end

    generate_completions_from_executable(bin/"scarb", "completions", shell_parameter_format: :clap)
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
