class Vapor < Formula
  desc "Simplifies common command-line tasks when using Vapor."
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/releases/download/3.0.3/macOS-sierra.tar.gz"
  version "3.0.3"
  sha256 "0461af9672896918e66bf3f698f0e78df0b8eb51c2a4a115919a0a30e055452c"

  depends_on "vapor/tap/ctls" => :run

  def install
    bin.install "vapor"
  end

  test do
    system "#{bin}/vapor", "--help"
  end
end
