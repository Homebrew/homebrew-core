class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "c848e4d8cf0451595266d56f94c1ae06b3c650642d3978e85745b73645fac043"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd770a555c858af63e4dfa2c9ff0dbc7adb369312ab341b8e8909b9b9e818152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650118751a4207421a74b6902d32f7da0553792498d19c54c29f81baab14e438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ec964dc1632994e23a0d75df915ec9230105a1d811a447e9d9b849d64b8314"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26817c53ac5e05a2825e6234cecebd915f028970c77034504c33e79a60700e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d432bff6034e4d5157eddeeb288fa8f863060342ad4c1dd2e8241ec7bb95d43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52994e88de648e61558a7d64c7a3517cbc51930c7a63c3ef5cd0cc3028e4f62"
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
