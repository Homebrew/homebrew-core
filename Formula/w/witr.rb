class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "3e3d8fa92b4240232db47288b937b9fef9f1d8b206145101ba5ef6a7ee1a7737"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59d36600adef9829276f1a2c90d1e75db8be57935a046edabffa3f3a3e435173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d36600adef9829276f1a2c90d1e75db8be57935a046edabffa3f3a3e435173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d36600adef9829276f1a2c90d1e75db8be57935a046edabffa3f3a3e435173"
    sha256 cellar: :any_skip_relocation, sonoma:        "853cc8a25b3e9c774dd177bf45bc833dc70fe8979888d516706076ad94dcc026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100f19e4be255b52fb2cc9f28979da82030e53f9d1a3320ce7ee0984852d2d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5764ea2154e4299bf01e595f9402fb6cdd554f221efd98ea040ee527cb978880"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end
