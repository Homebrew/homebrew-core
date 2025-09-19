class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.84.tar.gz"
  sha256 "831b130e297c4a21ef320ec44f946d220277a626f36bf039d89a86dac4a4b798"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e84d732c00b089540b0cc18e9984b495677fd59a1a583b2b5c76540e3488828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08069419277109ffca71e8a108870e113c563e4b3d626fee20b6f62d1779337c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e63b77dc697fd609c02547134beba347db139ef027f1e12035257f2b2d797b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd82ab073710183ad9dc6a2cb5888f7473cd7177b7b93fba01aa2b60488fb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c480553db816e5d6a266b49dd769a83de577229e140a18e6c1ffff39e8df24d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8465409c3baa04d6a3cb5f96915b3a888563290d0acd260b60dd9f86390d7b3"
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
