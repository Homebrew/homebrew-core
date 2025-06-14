class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "cc306c0420ee81d5bf0ab8f8c9ce17df2c33fb2152b050c6b8ef76309eb63942"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7fdd5bf457762c359ed0d9353f2da8a9bd0e76c67bd6ce5e35004126e15f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff7fdd5bf457762c359ed0d9353f2da8a9bd0e76c67bd6ce5e35004126e15f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff7fdd5bf457762c359ed0d9353f2da8a9bd0e76c67bd6ce5e35004126e15f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "33455a30df03c4cbf887121221834cd1c90fdb66bf7332555eaf409fa18e44b5"
    sha256 cellar: :any_skip_relocation, ventura:       "33455a30df03c4cbf887121221834cd1c90fdb66bf7332555eaf409fa18e44b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee011602b25f2749eab451a66de177fedffa446556ccf736a97ee9faef659fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
