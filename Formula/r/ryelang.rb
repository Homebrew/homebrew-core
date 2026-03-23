class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "545bacf885ffb407e39c7f121dba59429b721921e1213fdc61ed79c0f531caf0"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9862f04a4c6a1434231ef02f576d53ad522e891e5e0c2fab173a125578194439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc81f7f81f8f244ee43869aac398970999941ae51fc3ba75c0fcd354a0c2d1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be650fdc7e1789e801759f3ff0f213ba4fbf60946c2ab10af03b209f3c35a08"
    sha256 cellar: :any_skip_relocation, sonoma:        "e846332847e7aec01a092091e8c1134f41010db4fcbc0e88e949fa37f5230d57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d7ca971f4d7e4b30491de6ef939a0299d30b156d7af3d829bf38d89a9cb08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b72af395efdeef25bb08c5350ba256dd1e3921754c1459f3b208cccc10b7bf5"
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
