class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.3.1/xrootd-5.3.1.tar.gz"
  sha256 "7ea3a112ae9d8915eb3a06616141e5a0ee366ce9a5e4d92407b846b37704ee98"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "362424b968ff53f18f064954e2c5ced9565d7c2401e86b921efd645e66bfe0c9"
    sha256 cellar: :any,                 big_sur:       "c3a2b3d0e6078523c33a8256461615bde15c5444ce44da8ffba50ce6184db70e"
    sha256 cellar: :any,                 catalina:      "60141a86efe1880508a94a9aa935d7eeea4708d710fb1d32c39b84b4a3cac779"
    sha256 cellar: :any,                 mojave:        "402b1697b621101b2952acbbc9aae36d0b953b3a20acb1dbabc2ef9910e4734c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e05c2784cb3c302cdc0951d1755790cea3b63d3e05c78d3f672204a5f70b9e8"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DENABLE_PYTHON=OFF",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
