class Utopiops < Formula
  desc "CLI tool for utopiops.com"
  homepage "https://www.utopiops.com/"
  url "https://github.com/utopiops/homebrew-utopiops/releases/download/fresh/utopiops-0.0.3.tar.gz"
  sha256 "76267f9feff31860ba0d576a09075c1afb7e0e59266ab89037bf4db79301b364"

  def install
    bin.install "utopiops"
  end

  test do
    system "#{bin}/utopiops", "--version"
  end
end
