class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.61.0.tar.gz"
  sha256 "cd675a4ce734438f5b6b0eba28f5f1e275fdd58c387f03afc9eb37146779e18c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0444fe700db39ff88ff01ff5b02d066f54ebf3751b9e12b02d9cc74f7e6db2c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1874c1ce6dd6ceef51d65dad800fb5258675514319d71dd8eadee6cb6dcbfb61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c68fb2f41e94b6a1d8c5b7ffeb1cd4506261dd3eb178f24f714e823ff46e64e4"
    sha256 cellar: :any,                 arm64_linux:       "74cd71cf3f011eb16609063ad98d5112b8e5fbf3ab2f2af5902611edc4797efc"
    sha256 cellar: :any,                 x86_64_linux:      "31254ace0f2e0aae6cc08b57eb3a083879a60a3925acfe793522d353409b50c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "parquet")
    generate_completions_from_executable(bin/"xan", "completions", shells: [:bash, :zsh])
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
