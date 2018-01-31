class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://github.com/rbspy/rbspy"
  url "https://github.com/rbspy/rbspy/releases/download/v0.1.7/rbspy-v0.1.7-x86_64-apple-darwin.tar.gz"
  sha256 "58d0a1ff2c921aa3423a554188593970aab865f4e05b9b36b3cf263b023dfed8"

  def install
    bin.install "rbspy"
  end

  test do
    output = shell_output("#{bin}/rbspy -V")
    assert_includes "rbspy", output
  end
end
