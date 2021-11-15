class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg/archive/2021.05.12.tar.gz"
  sha256 "907f26a5357c30e255fda9427f1388a39804f607a11fa4c083cc740cb268f5dc"
  license "MIT"
  head "https://github.com/microsoft/vcpkg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8116bce6059d312ab0532fc41b37d7a1e96b3676aab2e36b1d700cdb4b777807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e58d2e3fbf843883563579ec544828788ca051c9b5bd46edc0e5df71c35b90dc"
    sha256 cellar: :any_skip_relocation, monterey:       "65fcbc684c9d1a081ce9e21efe81c81a6688eef365057abb14006cc264f6de01"
    sha256 cellar: :any_skip_relocation, big_sur:        "d963bef9ed861e8e67c4ef2080f04adf3a91bb971776f60f3f40bd5a6a875e07"
    sha256 cellar: :any_skip_relocation, catalina:       "143a0c4e50b0d96bdaa7ed913105654188664ac105500c74f66add89fe1cf098"
    sha256 cellar: :any,                 mojave:         "301a0c5460bebfa3f05fb2ed8d264fce2a9fe9f261853fed991a59d1c1cd58ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac3ac181306d79ac32984bdfecf34c9fa90703ed11e78044fae8630ca085222"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  if MacOS.version <= :mojave
    depends_on "gcc"
    fails_with :clang do
      cause "'file_status' is unavailable: introduced in macOS 10.15"
    end
  end

  def install
    # fix for conflicting declaration of 'char* ctermid(char*)' on Mojave
    # https://github.com/microsoft/vcpkg/issues/9029
    ENV.prepend "CXXFLAGS", "-D_CTERMID_H_" if MacOS.version == :mojave

    args = %w[-useSystemBinaries -disableMetrics]
    args << "-allowAppleClang" if MacOS.version > :mojave
    system "./bootstrap-vcpkg.sh", *args

    bin.install "vcpkg"
    bin.env_script_all_files(libexec/"bin", VCPKG_ROOT: libexec)
    libexec.install Dir["*.txt", ".vcpkg-root", "{ports,scripts,triplets}"]
  end

  def post_install
    (var/"vcpkg/installed").mkpath
    (var/"vcpkg/packages").mkpath
    ln_s var/"vcpkg/installed", libexec/"installed"
    ln_s var/"vcpkg/packages", libexec/"packages"
  end

  test do
    assert_match "sqlite3", shell_output("#{bin}/vcpkg search sqlite")
  end
end
