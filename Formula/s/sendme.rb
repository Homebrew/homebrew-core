class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "1afbc67d504ba595f5b1af42ced07dc64ba3db28addc00ff118a695b4619caf5"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a7c1cd0c78f5d6008a4ade143cf8e88231fc880003c7ed8802cbae5842cb904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06772217803a81c60c25c74a1adf49b1c2e29417cf64fb444718fcfd74c0396d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acfffa18736c279287a5e6b014447deb3220f0ec1f5c98c88b229b62c70b8e88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dd5c057bbe34a7c767523cd4140978e295e8e3284559762079b19439ae3a5e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee3d2666c6a5df0d95d529213b38f140ec5a15e3d3df60cd5bc82d57f8b64ac9"
    sha256 cellar: :any_skip_relocation, ventura:       "3293e722dc294d1ec48e5c4c2978ed4a7e381a5375d08d04c146c6e23550081c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22907543028dae17f8cac3c5b8921d3f72baf2aecb0e761cc552117bc4c2c0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2bb15b04c888b9cdbb1f46cc8263078185facc753ee04f6a0337f0dfdbb2248"
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
