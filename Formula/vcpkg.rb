class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg/archive/2020.06.tar.gz"
  sha256 "cfaecee6f18b6e2763f41c4257b6d6a1d2ef536a2018a6c7f579df0b6ad42e56"
  revision 1
  head "https://github.com/microsoft/vcpkg.git"

  bottle do
    cellar :any
    sha256 "e4b51bd648a112d77dc6f16f7e702f1edbd3f14a3dfe9bc29dc46ca996f26670" => :catalina
    sha256 "db0dc9240c0c62ad995b56cbb19bb7089a6463fd41fe01cf3d5cb860d408f564" => :mojave
    sha256 "e8b701d7a51ed48a27f93f6ac6e16f1f38118f5a9bfd15360594c5db6c19b881" => :high_sierra
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
