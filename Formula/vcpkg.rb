class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg/archive/2020.11-1.tar.gz"
  version "2020.11-1"
  sha256 "dcae747fddfc1540b57d576afd2ad5191611013cce0bf30f184a1535c3d90fbe"
  license "MIT"
  head "https://github.com/microsoft/vcpkg.git"

  bottle do
    cellar :any
    sha256 "e181bbe56ef0d1db7c1cae4a5c6fda76b876ae5a737dbf2748bd84e0b91d1dde" => :catalina
    sha256 "f055bfcd2264536b1b1b53d6c86d895d10da02a1984fba1350ee24693473dfe6" => :mojave
    sha256 "64cb1e7805e0908c553974dfe70e19533abd6f3b2ef3c6253276e417e91fc16b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

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
