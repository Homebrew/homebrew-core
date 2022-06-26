class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.5.1.tar.gz"
  sha256 "34cd97ff1e6f764436d71676e3d6842dc7bd8e2dd5014068da5c560fe4661f60"
  license "MIT"
  head "https://github.com/twogood/unshield.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67ec512a1440cd9789eeaec27ebec1f7d8ac8ca9ba1bf20994f75b880cdd383a"
    sha256 cellar: :any,                 arm64_big_sur:  "733440cfd3ab30313002e94a0384ddd6d86ae93d2460f9930ff4c7887261dfa0"
    sha256 cellar: :any,                 monterey:       "61708a9426f9a495a4ced1396ad2d89f9ecbdfea9ceefedf192adf17d0975dde"
    sha256 cellar: :any,                 big_sur:        "71733479817aa41beb3fe68201a3dbd352e4a0c8843caf92f3265d4d84709a42"
    sha256 cellar: :any,                 catalina:       "4722f61677e2a089ced4df43d131b827447cbca5eac319b52abec6bc68260a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c95d26fdd62d2125b26d3f1ceb5db36a7f9ce939ead9172fda18822720acca"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end
