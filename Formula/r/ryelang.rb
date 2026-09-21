class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.61.tar.gz"
  sha256 "af8926fd894a45c4b2f2b38eb93034b0bb5553da70848fee1a76f92f5c2696a7"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "132ad6f32fdc51ce49d3ef825190ae96ceb6d597817eba21eaec126c884f54d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cae8ea13e9bce3fcebf6d5cc0d23b2e918790db21846ec3f96833a705881a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6639ae44cc06a22d38242bde0b99ee1392a4d2d23c50556e9e1dd2f528974fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26a8da778e21e8fa2cae8574c9281d0e3ae9d70315078b08cdd186865ba5abe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8eed58b88ad7e01544fd3197eb98f72358d606b7a0690dd268639d56d9d1c401"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/refaktor/rye/runner.Version=#{version}]

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
