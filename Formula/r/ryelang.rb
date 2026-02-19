class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.1.02.tar.gz"
  sha256 "8901573e3109a0d80df46ef7e82dd88d97dfed24ac9b4a4274fe2cc9167f0996"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5607d4ff95e098a21d1c268b63c97cf30b32282f31b1fb97cbaa40172682473e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba42e33ef4a918b6e9d1e7f2db01df153ad45cd8b26c1bbee13b4e79e11df06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dbabce949a672f4997f110bdd24dad5007d28c80540a9c424b2258e0728b163"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07cfb7f15ba434c474fb708237784c0968d2b3f5e8fee2295e59f811eece82e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc1a2cccc76cdca7822077eb8a53d9f9aab0c47cb152919f0fd58483ffd1da59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "106a048e0c7df882b9c50a2e3ef3a3295c2feeb0d67ffe6e9789ce3c7f00b4bd"
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
