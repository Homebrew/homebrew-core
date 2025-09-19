class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "a159dc8440deec4801ca95fbf59d242d911c1a5546e15e7ae8dca8e4a058243e"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccc755dd7ab1aa81c9fd3fcbaa3a5cc02ccdb434225fbe7af0a69700efa7c33e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f83e361693063433fadd63b536d0446bfcbc82cd36132ccaebafa6e079c68c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b387db6c32227d3cc64057b9eb310ab67e327f8b91b395c61985e3401e049fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4616f13e54b9a8bc92c5e8d5d39925e28e333be46f84cc6caa1280ecfd89cae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa00882ee97ccc2f4421e67666f328e4712c615163bd9a13f444267e0343e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6423995127139a4c9f83674d17865a9bb43607212c971758f2897fb1fb7efa"
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
