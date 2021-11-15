class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.3.tar.gz"
  sha256 "aa8c978dc0eb1158d266eaddcd1852d6d71620ddfc82807fe4bf2e19022b7bab"
  license "MIT"
  revision 1
  head "https://github.com/twogood/unshield.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "203b32bff779c6547678a76cab4d9c77a94b0772969f7e51a267be0f8fecbea4"
    sha256               arm64_big_sur:  "d12579d6ed702bf8d4b9a37f45b6d9c527c88e60d648d935d93c969d0b6b78df"
    sha256 cellar: :any, monterey:       "3e0e5841f8f6a5244f2bc620ce4d2bdd35492fb40d3262c6eac73775e33ac9c7"
    sha256               big_sur:        "fe9c9710de87f7734c84e3454ba88a2c35b859fb8b8dfae56968c3c0bb4e76fc"
    sha256               catalina:       "d64e0c93743d7d50858bd5c46c76b8fa79183b5ee4643361202f53378a88cc05"
    sha256               mojave:         "ec5db176e7f9557645cfdb63062802d37a8e516f39f1e53037e37ed398992b3b"
    sha256               high_sierra:    "c68a5391b55e5101979c69d174160564d88edc7263afa140fd69ce289c6662ed"
    sha256               sierra:         "96cc0aa68d191d1bc98d09a48abaa44b58b4e979bfcec3b2abc384c30d56684d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end
