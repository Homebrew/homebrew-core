class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  # Using GitHub tarball rather than ftp.osuosl.org to support autobump
  url "https://github.com/rpm-software-management/rpm/releases/download/rpm-6.0.2-release/rpm-6.0.2.tar.bz2"
  sha256 "66a4998e020d7354a804fde83801a9d7157b20f5e08198f7fde69d3a0ab683fe"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # rpm-sequoia
  ]
  version_scheme 1
  compatibility_version 1
  head "https://github.com/rpm-software-management/rpm.git", branch: "master"

  livecheck do
    url "https://rpm.org/releases/"
    regex(/RPM\s+v?(\d+(?:\.\d+)+)(?=<)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "85b28257b443c715ec1ee352a3a2044138d008a8c1d9925bba9988bfc66bb864"
    sha256 arm64_sequoia: "fa56fd7e7b8c2a725abdaab889fa893c1f0741e3e3009178fd82b93ab3954bc5"
    sha256 arm64_sonoma:  "c678282544199c2d323b3fabecc4d771e4aedb3d7954bda00232b79705f250c1"
    sha256 sonoma:        "ee4352e0bd6d8895ef486d605d4f9f0ec87e4a163254ba3af9a6f6e5299e1ba7"
    sha256 arm64_linux:   "b16ba06fda8e6867c7bd6b6b8e6b9f6d49c2074edfed551ac87a2b0d3b9f673d"
    sha256 x86_64_linux:  "f4c414f88d69cda16b5996e7dfb1ce55f3fae917f763067f89b3cb5621455c9b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build # for rpm-sequoia
  depends_on "scdoc" => :build

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

  # Construct rpmstrPool with new so its std::shared_mutex is initialized on macOS
  patch do
    url "https://github.com/rpm-software-management/rpm/commit/5f2726246de792aac980867833b3357376145818.patch?full_index=1"
    sha256 "f25cf0f3e7cf26dd5c4d25684d37d6a190d4afa8b463a37ce0e0bf09f52ad4c0"
    type :unofficial
    resolves "https://github.com/rpm-software-management/rpm/pull/4291"
  end

  def python3
    "python3.14"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
              "/usr/bin/pkg-config", formula_opt_bin("pkgconf")/"pkg-config"

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
    (var/"lib/rpm").mkpath
  end

  def post_install
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
    specfile.write <<~SPEC
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

    SPEC
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
