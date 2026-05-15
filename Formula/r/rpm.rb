class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # rpm-sequoia
  ]
  revision 2
  version_scheme 1
  compatibility_version 1
  head "https://github.com/rpm-software-management/rpm.git", branch: "master"

  stable do
    # Using GitHub tarball rather than ftp.osuosl.org to support autobump
    url "https://github.com/rpm-software-management/rpm/releases/download/rpm-4.20.1-release/rpm-4.20.1.tar.bz2"
    sha256 "52647e12638364533ab671cbc8e485c96f9f08889d93fe0ed104a6632661124f"

    # Backport commit needed to fix handling of -fhardened
    patch do
      url "https://github.com/rpm-software-management/rpm/commit/e1d7046ba6662eac9e5e7638e484eb792afa36cc.patch?full_index=1"
      sha256 "ae5358bb8d2b4f1d1a80463adf6b4fa3f28872efad3f9157e822f9318876ad9c"
    end
  end

  livecheck do
    url "https://rpm.org/releases/"
    regex(/RPM\s+v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1462be8d84ff5e2619abf1ddf519aaf51117600fa0b34915160b8a5aa926dfb"
    sha256 arm64_sequoia: "e4bf476b54a1224dc7c4b91901f395a8fc51e4c3b0f6c7b386138e1bc1ea455e"
    sha256 arm64_sonoma:  "41375be050820e0d9b26786600bd888d8ad6e434e834787afa1cc182e6896736"
    sha256 sonoma:        "a8d1495a1eaef556377e085bca4d6e27dac67bbaf618f34e5eefb16e13103fa1"
    sha256 arm64_linux:   "9873698fe99788028cc539fc66818b1c5dade0780e2f02032a6a5ac95506975c"
    sha256 x86_64_linux:  "7815f575b463b87f6eca89a4f0f5c4192d4fd2206ce00b91c998c916787916ee"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build # for rpm-sequoia

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl@3" # for rpm-sequoia
  depends_on "pkgconf"
  depends_on "popt"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
    # See https://github.com/rpm-software-management/rpm/issues/2222 for details.
    depends_on macos: :ventura
  end

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "rpm2cpio", because: "both install `rpm2cpio` binaries"

  resource "rpm-sequoia" do
    url "https://github.com/rpm-software-management/rpm-sequoia/archive/refs/tags/v1.10.2.tar.gz"
    sha256 "ba740c16657498bb1a5a2b04472728089992e93a83d3584f00854b112dfd45df"

    livecheck do
      url :url
    end
  end

  # Apply nixpkgs patch to work around build failure on macOS
  # Issue ref: https://github.com/rpm-software-management/rpm/issues/3688
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/NixOS/nixpkgs/3d52077f5a6331c12eeb7b6a0723b49bea10d6fe/pkgs/tools/package-management/rpm/sighandler_t-macos.patch"
      sha256 "701ffe03d546484aac57789f3489c86842945ad7fb6f2cd854b099c4efa0f4e5"
    end
  end

  def python3
    "python3.14"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    resource("rpm-sequoia").stage do |r|
      with_env(PREFIX: prefix) do
        cargo_args = std_cargo_args(features: "crypto-openssl").reject { |arg| arg["--root"] || arg["--path"] }
        system "cargo", "build", "--lib", "--no-default-features", "--release", *cargo_args
      end
      # Rename the library to match versioned soname
      versioned_lib = shared_library("librpm_sequoia", r.version.to_s)
      lib.install "target/release/#{shared_library("librpm_sequoia")}" => versioned_lib
      lib.install_symlink versioned_lib => shared_library("librpm_sequoia", r.version.major.to_s)
      lib.install_symlink versioned_lib => shared_library("librpm_sequoia")
      (lib/"pkgconfig").install "target/release/rpm-sequoia.pc"
      ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    end

    ENV.append "LDFLAGS", "-lomp" if OS.mac?

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

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
    args += %w[-DWITH_LIBELF=OFF -DWITH_LIBDW=OFF] if OS.mac?

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
