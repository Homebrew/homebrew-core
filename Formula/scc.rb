class scc < Formula
  version '1.10.0'
  desc "For counting physical the lines of code, blank lines, comment lines, and physical lines of source code in many programming languages."
  homepage "https://github.com/boyter/scc/"

  if OS.mac?
      url "https://github.com/boyter/scc/releases/download/v#{version}/scc-#{version}-x86_64-apple-darwin.zip"
      sha256 "ddb892dc3a0b395de5cdd57015e9ac64b03983cf0c9437134e235d3631a993b2"
  elsif OS.linux?
      url "https://github.com/boyter/scc/releases/download/v#{version}/scc-#{version}-x86_64-unknown-linux.zip"
      sha256 "248a3593cc1f746374017e22eb555701c97844049c951fe966a65f102c99f350"
  end

  def install
    bin.install "scc"
  end
end
