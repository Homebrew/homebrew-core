class Vapor < Formula
  homepage "https://vapor.codes"
  version "3.0.3"
  url "https://github.com/vapor/toolbox/releases/download/#{version}/macOS-sierra.tar.gz"
  sha256 "0461af9672896918e66bf3f698f0e78df0b8eb51c2a4a115919a0a30e055452c"

  depends_on "ctls" => :run

  def install
    bin.install "vapor"
  end
end