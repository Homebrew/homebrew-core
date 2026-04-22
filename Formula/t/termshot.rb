class Termshot < Formula
  desc "Creates screenshots based on terminal command output"
  homepage "https://github.com/homeport/termshot"
  url "https://github.com/homeport/termshot/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "40abea3c9ae604f3c2cdc7e2a623bf6063c6b1c504a70c5e3a1b8457dbdd2fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9e84923bf4300c54e04efee620db1bde1ea367dcc0f2dfafba0c46b92dbaa4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e84923bf4300c54e04efee620db1bde1ea367dcc0f2dfafba0c46b92dbaa4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e84923bf4300c54e04efee620db1bde1ea367dcc0f2dfafba0c46b92dbaa4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "788fe895144017fafd44bb3df8973655f6ce930f28f814e677a06d9c2fd76c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e7a5aa03dfbc7a006bf75306ef8439d46d2f127437fee9498c0ab364234efe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d0eb5a80ad7724cc0f400cf54403ecd7a0fd7cb5a3ca11442465b3eb83352a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/homeport/termshot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/termshot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termshot --version")

    system bin/"termshot", "-f", "brew.png", "--", "termshot"
    assert_path_exists testpath/"brew.png"
  end
end
