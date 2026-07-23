class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "69897a9785c5b87c769417f77de8bff6e34e5391eed3d2df5d270599daf485ad"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f7f0524e038b8a3072a2d8ed153f5a93c049c3545157f42a3a6c826885c96a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca15d93e8ba160a1f0d0565ef798cabdb61e27f54a9caa28948eccb5f5ec080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a809e07c0afd0c99d3435ed74b0375746a24f8e0d4dc67af6905c8d1ab68ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "271ff4f22ee303866e8c45cf0ed278a33dc1513cf1d547dce2e542038def3a7e"
    sha256 cellar: :any,                 arm64_linux:   "10929be76d3000b5cdedc8a1d49ab08413947cc43fc6bcbfe2dc8c32131c149d"
    sha256 cellar: :any,                 x86_64_linux:  "f4629942a570de5a781197b8616e1da24bc23c3ae478f95252522b2f09c2c1c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 4
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
