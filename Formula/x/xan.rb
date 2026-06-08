class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.58.0.tar.gz"
  sha256 "434df1465d2752b932efc8556d4ffce1ac0db5303b45ccbb86d87ae591447550"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a28b8df224e26a93e7527add059cfd67854abd18077b77788052322c099597c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e71a0ce416933e992777583c5b68ccc2fd97d6772d8ba6a4dc73cdf016d0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19332ea90f4e247f9cdbb511904d72cf399521c0d9bb2e166d8a29c752e30507"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fec45f395a4e1d617cae72e938e79fa10c68ea23f326633429829973e93b498"
    sha256 cellar: :any,                 arm64_linux:   "60b9aef54d1fe969fbbfb566241538e6fa22af47e393a978c23e0300682c87f0"
    sha256 cellar: :any,                 x86_64_linux:  "2fa7e9799b0e169fc0c076f5553932c68a6133189e9f70626386ea5dd7cb1c7f"
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
