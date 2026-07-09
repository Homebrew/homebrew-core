class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "8236bc0f71a7aa2639163a56262a4817aecc75b79232a199f82d758d7a12a129"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6edd7fe5d8c0438adb0208e6b9a709f3b048d0bbf98ccda19cf0477928e191ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829b9aca3624a7fcb26d2696af0938b0b99fc066bff49122f4b6ee95d6731c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b2cc8de17c0f76305c69dc1544de261732b33504cb8af2182af02088c76ca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c802d371b8e832766550a1e876319d5e902915e36bd019d6586209177de50df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65ec8051cc8ec7d174ba3fd18cac520d4b766e56148b2314694ef59eb0ccf33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d5ce0add659cc360922d6bb2028e9206f95f6c8044923635a2ce42f04f0074"
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

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
