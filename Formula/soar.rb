class Soar < Formula
  desc "SQL Optimizer And Rewriter"
  homepage "https://github.com/XiaoMi/soar"
  url "https://github.com/XiaoMi/soar/releases/download/v0.8.1/soar.darwin-amd64"
  sha256 "1938433fcba35e40757489bfc135b7668ad614e99cc6c1cdc05f76fe2d6f9e45"

  def install
    bin.install "soar.darwin-amd64"
    system "mv", bin/"soar.darwin-amd64", bin/"soar"
  end

  test do
    system "soar", "-version"
  end
end
