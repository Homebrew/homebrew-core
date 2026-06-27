class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "4f0f827e7d6fa39f66ac11e97ff44292f73ef5b7000a590eaa1e7ef80ac28364"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4628a1ef39cde646ced0b33bfd1207bc2ae5fc5bbc23a9c326c7fd85ea7c1685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637a3409175084930a9eccd2ac44c90b9aeda948c467b04184cc1764897c223e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bede46ebdff3805f876c7ddc443e3374a5de71a5cd870d84a3e96b788dcb9e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "3055f6a5d7dbd15fe1c1cfe03f11052261dd611e216f84a5dbef47611f58eb68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c769f13c3d802e261b5ba38ce0411d005fb8b8ea64df8877651245e98262c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd1d9a0e895a7f0f90ad5fa42bc712b843d39e879ce35aea0cd20f5effa7ced"
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
