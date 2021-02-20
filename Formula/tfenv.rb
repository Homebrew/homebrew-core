class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v2.2.0.tar.gz"
  sha256 "628c55bca9adf96a8d31c3f95b01aab170c3002c150ceb22cadd03366854d071"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  uses_from_macos "unzip"

  conflicts_with "terraform", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
  end
end
