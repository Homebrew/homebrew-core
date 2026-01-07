class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "https://ftp.osuosl.org/pub/rpm/releases/rpm-6.0.x/rpm-6.0.1.tar.bz2"
  sha256 "44fd2e1425885288ce8e8da8f18e6b85bd380332c2972554a85860af10f86d0f"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-or-later", # rpm-sequoia
  ]
  version_scheme 1
  head "https://github.com/rpm-software-management/rpm.git", branch: "master"

  livecheck do
    url "https://rpm.org/releases/"
    regex(/RPM\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "817cfbba4fe88dd1ca4446d936bb6c4cae68f70af1895e72b2d9af20186fc6ea"
    sha256 arm64_sequoia: "2ceece493065a153759bd8a81b001e1ae817b0315bd322aaf0190cd84b063910"
    sha256 arm64_sonoma:  "4bf279262ec127bb86a4b685f6a7e8ea3b854d865c71a173d2b3e4a1401db64b"
    sha256 sonoma:        "11d285a8bf603a8d7ae76af2d102c6c34ecf272cc5378335a3b6e5684605560d"
    sha256 arm64_linux:   "eda731a1351179e9a65f885cdf588db00f9e417b670328366bce636c13143916"
    sha256 x86_64_linux:  "70eaf4ff4ead4d9aa599087e5be5998ab22827cfef4f54d1ed5e682b61f7c05b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build # for rpm-sequoia

  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  # See https://github.com/rpm-software-management/rpm/issues/2222 for details.
  depends_on macos: :ventura
  depends_on "nettle" # for rpm-sequoia
  depends_on "pkgconf"
  depends_on "popt"
  depends_on "readline"
  depends_on "scdoc"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "libomp"
  end

  conflicts_with "rpm2cpio", because: "both install `rpm2cpio` binaries"

  fails_with :gcc do
    version "14"
    cause "Requires C++20 <format> support (GCC 14+)"
  end

  resource "rpm-sequoia" do
    url "https://github.com/rpm-software-management/rpm-sequoia/archive/refs/tags/v1.10.0.tar.gz"
    sha256 "efbc5ec47e7ca53c030d2a86d25702c811ee8f6046118ddbf3f983db3a7762fb"
  end

  def python3
    "python3.14"
  end

  patch :DATA

  def install
    resource("rpm-sequoia").stage do |r|
      with_env(PREFIX: prefix) do
        build_args = ["build", "--release"] # there is no `cargo install`-able components
        system "cargo", *build_args, *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
      end
      # Rename the library to match versioned soname
      versioned_lib = shared_library("librpm_sequoia", OS.mac? ? r.version.to_s : r.version.major.to_s)
      lib.install "target/release/#{shared_library("librpm_sequoia")}" => versioned_lib
      lib.install_symlink versioned_lib => shared_library("librpm_sequoia")
      (lib/"pkgconfig").install "target/release/rpm-sequoia.pc"
      ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    end

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    if OS.linux?
      ENV.append "CXXFLAGS", "-stdlib=libc++"
      ENV.append "LDFLAGS", "-lc++ -lc++abi"
    end

    # fix error: static declaration of 'delete_key_compat' follows non-static declaration
    inreplace "lib/keystore.cc", "static rpmRC rpm::delete_key_compat", "rpmRC rpm::delete_key_compat"

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkgconf"].opt_bin/"pkg-config"

    # work around Homebrew's prefix scheme which sets Python3_SITEARCH outside of prefix
    site_packages = prefix/Language::Python.site_packages(python3)
    inreplace "python/CMakeLists.txt", "${Python3_SITEARCH}", site_packages

    rpaths = [rpath, rpath(source: lib/"rpm"), rpath(source: site_packages/"rpm")]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_SHAREDSTATEDIR=#{var}/lib
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_NLS=ON
      -DENABLE_PLUGINS=OFF
      -DWITH_AUDIT=OFF
      -DWITH_SELINUX=OFF
      -DRPM_VENDOR=#{tap.user}
      -DENABLE_TESTSUITE=OFF
      -DWITH_ACL=OFF
      -DWITH_CAP=OFF
    ]
    args += %w[-DWITH_LIBELF=OFF -DWITH_LIBDW=OFF -DENABLE_OPENMP=OFF] if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  def post_install
    (var/"lib/rpm").mkpath
    safe_system bin/"rpmdb", "--initdb" unless (var/"lib/rpm/rpmdb.sqlite").exist?
  end

  test do
    ENV["HOST"] = "test"
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath	%_topdir/tmp
    EOS

    system bin/"rpmdb", "--initdb", "--root=#{testpath}"
    system bin/"rpm", "-vv", "-qa", "--root=#{testpath}"
    assert_path_exists testpath/var/"lib/rpm/rpmdb.sqlite", "Failed to create 'rpmdb.sqlite' file"

    %w[SPECS BUILD BUILDROOT].each do |dir|
      (testpath/"rpmbuild/#{dir}").mkpath
    end
    specfile = testpath/"rpmbuild/SPECS/test.spec"
    specfile.write <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      echo "hello brew" > test

      %install
      install -d $RPM_BUILD_ROOT/%_docdir
      cp test $RPM_BUILD_ROOT/%_docdir/test

      %files
      %_docdir/test

      %changelog

    EOS
    system bin/"rpmbuild", "-ba", specfile
    assert_path_exists testpath/"rpmbuild/SRPMS/test-1.0-1.src.rpm"
    assert_path_exists testpath/"rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm"

    info = shell_output("#{bin}/rpm --query --package -i #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match "Name        : test", info
    assert_match "Version     : 1.0", info
    assert_match "Release     : 1", info
    assert_match "Architecture: noarch", info
    assert_match "Group       : Development/Tools", info
    assert_match "License     : Public Domain", info
    assert_match "Source RPM  : test-1.0-1.src.rpm", info
    assert_match "Trivial test package", info

    files = shell_output("#{bin}/rpm --query --list --package #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match (HOMEBREW_PREFIX/"share/doc/test").to_s, files

    system python3, "-c", "import rpm"
  end
end

__END__

diff --git a/rpmio/lposix.cc b/rpmio/lposix.cc
index 3f66f70..c00364a 100644
--- a/rpmio/lposix.cc
+++ b/rpmio/lposix.cc
@@ -9,6 +9,16 @@
 #include <config.h>
 #endif
 
+#ifdef __APPLE__
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#else
+extern "C" {
+extern char **environ;
+}
+#endif
+
+
 #include <vector>
 
 #include <dirent.h>
@@ -422,12 +432,6 @@ static int Pgetenv(lua_State *L)		/** getenv([name]) */
 {
 	if (lua_isnone(L, 1))
 	{
-	#ifdef __APPLE__
-		#include <crt_externs.h>
-		#define environ (*_NSGetEnviron())
-	#else
-		extern char **environ;
-	#endif /* __APPLE__ */
 		char **e;
 		if (*environ==NULL) lua_pushnil(L); else lua_newtable(L);
 		for (e=environ; *e!=NULL; e++)

