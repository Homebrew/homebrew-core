class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://github.com/lusingander/stu"
  url "https://github.com/lusingander/stu/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "b37e3f241f224f76a35934649ea466bde9c069fbcb7c11dfcd67f42214c070ee"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37059ab0970c815b6e054bbd60fedabc0bf2195201e4370f792d20e36ba52439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c919d79d03b34ea3fc6c9ab6bf4a9f34cafbfeb15004a650bd1b56ed4dbfd35b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2ced87e55ac63fe2a6d170a1971573f2e2e153b4ecd188c3f2a8ff74c68c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14fa6797e6e10dc8976102b567734abb35495a069cdce7a3291e30a79bd255e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead74b7aa236fc2a96c9aa085ca9957743f5c10600d040c289f267e3c79e3181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35c96dcf427fedd0e171273dc5654f0abc41628e38f14320e93e07d9cd1a1b0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end
