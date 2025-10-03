class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.0.tar.gz"
  sha256 "c2288998dc0eeece287934e016d1501d5c200aa8047553d7405f3c3e0e5edac8"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "dcbe0e1ab47f4df406a67c2ba36054b073b2b66f0b1477dd2c60b5b04f264dd6"
    sha256                               arm64_sequoia: "bd097193791e63281d066ec0d9f09ce00854f3d4f175acf2c8f7de2e97bd9711"
    sha256                               arm64_sonoma:  "42f3015de22c4c0df1c0c0ddbc3f4cbf2f8fc6d5c46a9f4b3e3605ca19d1ae1f"
    sha256                               arm64_ventura: "42838c978555ceedc54abad930c4736964281a77f095a85e240a6cf610db19d4"
    sha256                               sonoma:        "126644d2dd8f755098164f18dcc0c203eedfc68f3d1291e2ac3f6e4e08f16114"
    sha256                               ventura:       "854851a3278513211d5e60512a140e73e9da82de03340e4e8a132593a462fdf4"
    sha256                               arm64_linux:   "c520b7e380d1573fab48e2d62fc63725e61522a25ca7258132c5c034e465e53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ced0f9be25f913ec6bec008639b7d37c64437de7e10651010d809842234144d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  # Workaround for Boost 1.89.0 until fixed upstream.
  # Issue ref: https://github.com/EttusResearch/uhd/issues/869
  patch :DATA

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end

__END__
diff --git a/host/CMakeLists.txt b/host/CMakeLists.txt
index 746a977bd..815c2a2c8 100644
--- a/host/CMakeLists.txt
+++ b/host/CMakeLists.txt
@@ -306,7 +306,6 @@ set(UHD_BOOST_REQUIRED_COMPONENTS
     date_time
     filesystem
     program_options
-    system
     serialization
     thread
     unit_test_framework
diff --git a/host/uhd.pc.in b/host/uhd.pc.in
index 4a5f67c96..e1a8115a9 100644
--- a/host/uhd.pc.in
+++ b/host/uhd.pc.in
@@ -11,5 +11,5 @@ Requires:
 Requires.private: @UHD_PC_REQUIRES@
 Conflicts:
 Cflags: -I${includedir} @UHD_PC_CFLAGS@
-Libs: -L${libdir} -luhd -lboost_system
+Libs: -L${libdir} -luhd
 Libs.private: @UHD_PC_LIBS@
