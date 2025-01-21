class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "09b28a3fde07cbaef334e378f380ba8e261ec7c065ac712d1edf313537380303"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c64291e9a805ccbc876c2a9b1035e554fe4fcbd3afdc9adc6447b61fcd12e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6823ca6dc97fb69f0f0633f640f47a08627ac68475153ae6cff6e4808729209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2049c135e3706ea73ae0771c4568730d6aeeaa79a2eb46ecef99594184b48f78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bc2b6754cd7a12356f8a4ab967d6824c1badc972eed51a5bedb1055859ed65"
    sha256 cellar: :any_skip_relocation, ventura:       "4d5fb6f42c0290a536f0089304a6b694beb12a9c079e41bd5fe1cbc80648411f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f70bca1e1949158ab4e9d172a91d3adde4267d11be1143be9c7ffa793c4fac7c"
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
      sleep 2
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
