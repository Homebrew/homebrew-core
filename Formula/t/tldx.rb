class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "e331e89c3d39c79d6efc4b3567f2c134da29761e58621239a54bab3423fea575"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee3f3737f626b5d4067b6f6dcaab5b701de0e9b4a778ea6c2fc1333e585fbb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee3f3737f626b5d4067b6f6dcaab5b701de0e9b4a778ea6c2fc1333e585fbb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dee3f3737f626b5d4067b6f6dcaab5b701de0e9b4a778ea6c2fc1333e585fbb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8ee3db8e9a3207acc6b7658ed5fc9618d5b88a772bd55f96c1796f6e7b34e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "918916d3f78b5f9c0743f09d40f7eb6f5ceff45263b28a74758baf4d22dd4a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea163e27018a816ff5291c76f79d4358e822bc79607c060ead16428f9a3afb6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"tldx", shell_parameter_format: :cobra)
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
