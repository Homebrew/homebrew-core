class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.60.0.tar.gz"
  sha256 "eec65a0467fd58a8049648ed4bb93f12fd63da6f0ee55de11f785148638eeeab"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "716f0c603a05605f8983de2d3e29f76500bf6f94cc4d5af0b4e2bfd7d3772323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e49210fdad82b8a53aac79c900338f98c2e0f477826b8a57809b276e67c89903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aceeb1b380044c0d1e8025af6f34bdb6f4727af08decc66eadfe0f0d115a50da"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a632caaed3be71cc9ce49df9ca3b9f3eb2039f3b8101d15a35bbbc276232266"
    sha256 cellar: :any,                 arm64_linux:   "bd1a472186a5f1860cd030119147fc25a396cee29354e345bab59e52f7f345d3"
    sha256 cellar: :any,                 x86_64_linux:  "f6b797e675483414b157966dcc6cab3521ccdc831d3880632b575329b9a614f6"
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
