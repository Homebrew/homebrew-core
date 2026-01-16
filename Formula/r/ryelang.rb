class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.97.tar.gz"
  sha256 "7bb6a60946b37ac96206c6bea9880bb6bf0a65a2728fa52c5f1d158994d3ecbe"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146fe3b7c328453f12f3e5b44bccb5fcfdaff4f051dbda582088eab8dceebb64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4413191e531e89cfd19e09f5a3ab04d02471eac479cc86fcb02c2dbec09e4a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e323af92d94d6324394f5e3a3cf8d327ea0fe97cd87353c31310011368115df"
    sha256 cellar: :any_skip_relocation, sonoma:        "0206b0016aafe1e37fd5f8b5885b3f29ddda2f7ef7694eeda7fd2d4c51e15c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c820494e89fcec1a266dc45cd37ffa8bfb9845fa618cef130b51ff9ab1cb29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0179eac91c6bf30f5ff80d8c560461b332adcc6839a4a570ed86bd8bdc3fbce6"
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
