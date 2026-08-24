class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.60.tar.gz"
  sha256 "c098887fbb5b7208c9b829f5f230832a57cd34f333f95dc1984dde985a61fbaf"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "137e428da22c9715f3ac1c429e9f8b3d568bd3600f460d53a5389dea8e7a1785"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0306c5f59086d2d23aa3c0a4f767477e109c693c88ae7d2f1d797cb391127a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a3d34c9164a5b4ce7c7a59a427597fd3c46722928a5d9e5e0c06d90ed23f280"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a74a5b9b7ac7c35f6e2aa68a09fc6db3bc906af01bda984f6dcfb0edea8734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ec96abefc06d865c001f938d64bc6abad63e62ad1727c0e64c8fca1e11304a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e082248a1710d7e8701dd706fb9745ea0fd49a894eea890a4eba214241997261"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

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
