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
    sha256 "5d02a65c2f0d49ee6af1b6af90a3daa5fbabf62c8b1552d18ae10c85eb6cba1f" => :big_sur
    sha256 "585cc3fd22497deca02ec61dd63b14653fcb59258f14f3313110d323f240102d" => :catalina
    sha256 "0e5f3a484461879e358301f2b3e26d26fbd726d5d0495e57c934ecab99e189a7" => :mojave
    sha256 "79a09d5626c2dc3230e03d412b27762531ae7d7a223653a29666a93d30acdd43" => :high_sierra
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
