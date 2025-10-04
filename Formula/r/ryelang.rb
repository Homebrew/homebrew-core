class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.85.tar.gz"
  sha256 "a721bd59fdaeb478810b0529e182fd9182a331e8511cf9a8d34872579886b6ec"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb20cc317e5ceb30d571d43aa4e2fcbc4d068135387b9036b5a67e9dd1e53e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0175a8a7886086f99a99606244100365f08d00c8767a0a28800069d50f674af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8e0552cd92047d943ce3abe15f7b8815be7374c991d10e0451295123a9cea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd81b0380cbe27eb5498829fc9ebb998d68b8818daad91d9e4e24779b83e116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55fc08ceff096a387903ed0ba6e7ad7e017eb8f018e7a7fdd7e5537c902f8833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f2b1374b2e7896304765b00b46729ddf8bc12644cf8832d693817aa4b708ea6"
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
    assert_equal "Hello Mars\n42", output.strip
  end
end
