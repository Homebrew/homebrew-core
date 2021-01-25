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
    rebuild 1
    sha256 "b0eeafb5709891c77ab0b05e8b6ce6977b72d30651869dfba98f6b501048fbc3" => :big_sur
    sha256 "9dcff0e796b3e9b34dd365e79e114a862bc297b289a64703698badf5a9b84cac" => :arm64_big_sur
    sha256 "37195113f690360e2e6efd0f4657f5b0e60f4a65e2c37ee25558bf8488d1aeb8" => :catalina
    sha256 "f1c8ef840126a72be1ed20a9f032bcfe25fdf4c30f3adb1da0e0905d7075a8d7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  if MacOS.version <= :mojave
    depends_on "gcc"
    fails_with :clang do
      cause "'file_status' is unavailable: introduced in macOS 10.15"
    end
  end

  # build fix for arm
  # remove in next release
  patch do
    url "https://github.com/microsoft/vcpkg/commit/7f328aa.patch?full_index=1"
    sha256 "afe40ee3c294b85f062dc1598ff0cd7ae4f550336ac0b13f2a4f0226c50c501e"
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
