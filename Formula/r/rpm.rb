class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-or-later", # rpm-sequoia
  ]
  version_scheme 1
  head "https://github.com/rpm-software-management/rpm.git", branch: "master"

  stable do
    url "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.20.x/rpm-4.20.1.tar.bz2"
    sha256 "52647e12638364533ab671cbc8e485c96f9f08889d93fe0ed104a6632661124f"

    # Backport commit needed to fix handling of -fhardened
    patch do
      url "https://github.com/rpm-software-management/rpm/commit/e1d7046ba6662eac9e5e7638e484eb792afa36cc.patch?full_index=1"
      sha256 "ae5358bb8d2b4f1d1a80463adf6b4fa3f28872efad3f9157e822f9318876ad9c"
    end
  end

  # Upstream uses a 90+ patch to indicate prerelease versions (e.g., the
  # tarball for "RPM 4.19 ALPHA" is `rpm-4.18.90.tar.bz2`).
  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*))\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b68a3e9add758b36a2547372709f655d29948680c2403d8819a46445a9211a50"
    sha256 arm64_sonoma:  "7319baf421ef56e8cdf5e937f0624a5ff14521d0d045d27446611faede12a0f8"
    sha256 arm64_ventura: "5070355f11041aedf2f1559a4b04af7e87c596576e80c54db3e2674b6d40bd69"
    sha256 sonoma:        "bc5c3289f2afaf8d6c12b1f530284be837ad9ab1c7376b1da93feb4b8588f2b1"
    sha256 ventura:       "b47ab72d2f0b6d82eb7cc20e3b69655e92367ea9b5700834330bd76eb2c7eddb"
    sha256 arm64_linux:   "25fc73da026efc9660a4373b10837df0c99f773ad000ddda3a3d07dcab1a459a"
    sha256 x86_64_linux:  "529d59e759920b457292f5a378ccb796bf6d98587e6bb1d2b51ac2a17f1bb678"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "python@3.13" => [:build, :test]
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
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
  end

  on_linux do
    depends_on "elfutils"
  end

  conflicts_with "rpm2cpio", because: "both install `rpm2cpio` binaries"

  resource "rpm-sequoia" do
    url "https://github.com/rpm-software-management/rpm-sequoia/archive/refs/tags/v1.8.0.tar.gz"
    sha256 "a34de2923f07b2610de82baa42f664850a4caedc23c35b39df315d94cb5dc751"
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
    "python3.13"
  end

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

    info = shell_output(bin/"rpm --query --package -i #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match "Name        : test", info
    assert_match "Version     : 1.0", info
    assert_match "Release     : 1", info
    assert_match "Architecture: noarch", info
    assert_match "Group       : Development/Tools", info
    assert_match "License     : Public Domain", info
    assert_match "Source RPM  : test-1.0-1.src.rpm", info
    assert_match "Trivial test package", info

    files = shell_output(bin/"rpm --query --list --package #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match (HOMEBREW_PREFIX/"share/doc/test").to_s, files

    system python3, "-c", "import rpm"
  end
end
