class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "1bdb44f8fbda439f4121aa25ec3b99a89157bf2a79bd0ec9a3ba56798d9da0da"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85dc62bdb8c5011b77183cc81991b6c17e929835a6b866c9d7f10b5094e58f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09c7307c658ae61af79c0bfd7414436e19597bcb44c113cdd3f508ceccd4d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6bb20ce107c0809a92764c8e3108736ec7873cb380a4c43c244beea224b0bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e161ea76d58b5118127f6a388539aff7f8443e4f57e800e74f986a1967852efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79684d62b39d4c00773622fc297b6538c89d39f707c994b3e013877d97443f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8127a592d6c68feebea4355d86b18ab97014e5ab88d6bc49c408c3af5a55bde3"
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
