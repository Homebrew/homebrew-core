class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-or-later", # rpm-sequoia
  ]
  revision 1
  version_scheme 1
  compatibility_version 1
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

  livecheck do
    url "https://rpm.org/releases/"
    regex(/RPM\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "9c214ce074bddb955970b60106ebc155f0783a04e2af65080268ccecf7bd499b"
    sha256 arm64_sequoia: "ec075b7ef916195ac245a831715ca4305641d607f5c82e9f81b437aa20d5ab8e"
    sha256 arm64_sonoma:  "cc9845e73233b057da077d3504d8f5a19fcedffdac8a38965246b6c162030b49"
    sha256 sonoma:        "862e0efee8b4876888c728c3921168cc1cb8ae74d4a787ef81278cd96d873e71"
    sha256 arm64_linux:   "c8a0598905a3f1eb1c6ca3ea74e9e1313434a6055b9a45ff7c2500facfed373b"
    sha256 x86_64_linux:  "936bb8258a1b95397a71270123f6298891fab5b9829c80447721693aa7e45a56"
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
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
  end

  on_linux do
    depends_on "llvm@21" => :build # LLVM 22 fails for nettle-sys
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
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
    "python3.14"
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
