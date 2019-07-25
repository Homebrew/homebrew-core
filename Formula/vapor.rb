class Vapor < Formula
  desc "Vapor Toolbox"
  homepage "https://vapor.codes"
  head "https://github.com/vapor/toolbox.git"
  depends_on :xcode => "11"
  depends_on "openssl"

  stable do
    version "18.0.0-beta.17"
    url "https://github.com/vapor/toolbox/archive/18.0.0-beta.17.tar.gz"
    sha256 "202208026843dbf68ec54a13fe08db1c41d3d39e8c060fdbb723f192b88ecd8d"
  end

  def install
    system "swift", "build", "--disable-sandbox"
    system "mv", ".build/debug/Executable", "vapor"
    bin.install "vapor"
  end
end
