class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.3.tar.gz"
  sha256 "75fb95b1607fdd2fb9f7795d3432d295904614150575ae539202f680499803c9"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "b250877285b24e95df9b86883bc09faece5236a4708efa93493a0434c049ac57"
    sha256 arm64_big_sur:  "201982a36d116f80314330dc00ac78c98cf4e7cfe8803addecf8f5fad2ec15d2"
    sha256 monterey:       "a0db3441f9d2f128d419cd7b9e2be0c30a0b0e476a76f0ed388fe486db5090d2"
    sha256 big_sur:        "15fa01158f88b31fb8f6d18e8e8e3c76492c0693fefee8245f25ac3913041bb0"
    sha256 catalina:       "4831ddd61d8b9e9b7024cfc898d4e7e4c89207276ac2a4bc5b22911294d3e8b6"
    sha256 mojave:         "98f5f41515dc5b1dbf8ca9bb7f47990c9c5852a8f5e56a93da303fcb024ef411"
    sha256 high_sierra:    "9e95490034c0b964cf617e05361ac7128a5e5e886ea38dcc4f14b64468c328ac"
    sha256 x86_64_linux:   "21ba061b7f3f91eca4a326a66730dc88c846dc0e373f581b7c0052674a9d9c4e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end

  test do
    system bin/"sdcv", "-h"
  end
end
