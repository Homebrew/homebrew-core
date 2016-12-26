class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.tar.gz"
  sha256 "8ae91961212193a7d3d7973c1c9464f3cd1967c179d6099feb1bb193912f8231"
  head "https://github.com/twogood/unshield.git"

  bottle do
    cellar :any
    sha256 "ba6bf0f4336db7dc0a4786c914641dbd5cbb7e8a78372fca8fb44d234971b9bb" => :sierra
    sha256 "3483cb438e816f4a88d9c0f166a73aa40c042e96b49955a9280d42b5d8f65f47" => :el_capitan
    sha256 "9e143d03e6017dd8aa55696e3d5e8f0f0c2e25c6d5fefb496d6fa3cf113e10aa" => :yosemite
    sha256 "804098ab7f9c7ecac5d8749d7b13d542b07dd3551170da17568a073710740ac6" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unshield -V")
  end
end
