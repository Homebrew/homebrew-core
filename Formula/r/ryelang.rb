class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "cceae8e311f4514d929e3e475b9a46ff939e6914b8cb6df6fee5e92ef2645f4b"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3253ebc4a2431bb5a2c05332c835dc5208def61e2ed66342abecac3281c73ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d919fe18e5235b25d6b00ec3b5f2d33f3272d6abde765a8d778597d16452025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23dd8ad8b541493b6243424259456979ede53b9b255ccde92f6beda74afd0730"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dd2f5d2e155e05df4c20aed8cac4e7d3db0fe422fa0424796e695a320096667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3759fea98395875a7d3f1ea86922249afdb27b6181ff78635298d941f63be87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627a5381205d2b7df83a4a995e80354390d68aa448c2e0ca9452fa227276b353"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
