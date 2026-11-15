class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  stable do
    url "https://www.swi-prolog.org/download/stable/src/swipl-10.0.2.tar.gz"
    sha256 "e42cc098f7b8a6051c4f79a99b55162d467098aba60f69649bdc7583f0734b57"

    # TODO: remove the resource and patch when the stable release includes the
    # prebuilt icon (devel 10.1.13+)
    on_macos do
      resource "swipl.icns" do
        url "https://raw.githubusercontent.com/SWI-Prolog/swipl-devel/05262941a70720fefdd16f649f03e50fe2b069d6/desktop/swipl.icns"
        sha256 "022530bf60d40ae425a32d7758d4bfc1896b2b99e3238a6a051d68bd49397562"
      end

      # Backport of shipping a prebuilt macOS icon instead of running `iconutil`, which the
      # build sandbox does not allow. `patch` cannot apply the binary icon in the commit
      # (GNU patch rejects git binary diffs, Apple's skips them), so it comes as a resource.
      patch do
        url "https://github.com/SWI-Prolog/swipl-devel/commit/05262941a70720fefdd16f649f03e50fe2b069d6.patch?full_index=1"
        sha256 "7d0c7ebfad36ef48c8511c3caa1a4a042d62438155e8377f70dd79288947173a"
        type :backport
      end
    end

    # Backports to support OpenSSL 4
    patch do
      url "https://src.fedoraproject.org/rpms/pl/raw/7ce89990c46ecd45cf6fc9a5106d9aad9325df00/f/swipl-10.0.2-openssl4.patch"
      sha256 "fbed115159222ecb936f56354f3c40bfa092dd135ab5a482ee0a9f2e6d27939a"
      type :backport # https://github.com/SWI-Prolog/packages-ssl/commit/24cff8cff7f8c32633fb883d99f3d8b8cc3c5bec
    end
    patch do
      url "https://github.com/SWI-Prolog/packages-ssl/commit/7673a282d2868d69172ecfbcc0824eb6b47d373a.patch?full_index=1"
      sha256 "17b18f612872a876e163d1cfb5600d41d870dd0c8244ea2cd7a03c24cc44f530"
      directory "packages/ssl"
      type :backport
    end
  end

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "10fcaf0f3d633f8321a2c9f0a2663f81497fc814918a64e3be9f73b7eebefaed"
    sha256 arm64_tahoe:       "a8f6c8b08a159d40d071df244c9f9f346741820a4f17015398fc47872e765e6f"
    sha256 arm64_sequoia:     "f0fcaea1c6c5393d63e45d5e8f843e587936ec0c3dd668ce5b211222da28d923"
    sha256 arm64_linux:       "bd56b397c7384d3a92fccc12ae55fcdc506445d6e2b348852f09d48cefe4876d"
    sha256 x86_64_linux:      "227daf585ace6d5a86bed58f53f15e458d6bd744edc0db1cff68cfbf89054f14"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "unixodbc"

  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Remove bundled libraries
    rm_r("packages/libedit/libedit")
    (buildpath/"desktop").install resource("swipl.icns") if OS.mac? && build.stable?

    args = %W[
      -DSWIPL_PACKAGES_GUI=OFF
      -DSWIPL_PACKAGES_JAVA=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
      -DSYSTEM_LIBEDIT=ON
    ]
    # Let Homebrew's build environment handle dependencies
    args << "-DMACOSX_DEPENDENCIES_FROM=None" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~PROLOG
      test :-
          write('Homebrew').
    PROLOG
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
