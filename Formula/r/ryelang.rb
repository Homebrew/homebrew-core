class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e7dc24cd60c3f23ffad0f357ed143bc7c96a02fe244a3a9d535f3b9d0b97be33"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6013700be5a45308bb74e958c63a3221fa56e152e62b28cabb57ca34b7d27324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc2026a1911128ba192e0458b4326eb6d35fc376f6e5c7241e726c7b16fd90b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7490cf519c5130803c7c994f4ba52cab8fb13161fd7cf93af33d821eeaf48567"
    sha256 cellar: :any_skip_relocation, sonoma:        "11dd6c4545d94db69e5fdaaced81ac08e7ed3baa6571f196f8ab45cb067ab8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fad08414c7c473f8eaa5c4ee9b79ee98af5eec0e417714c41993ef9d9219381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f29b87d96b0a71b2d4c6ea570177d8c4c8c56c1e21269cad75eacc32b006ab"
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
