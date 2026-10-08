class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "369d789ae5616e6e43b5eeb6feac644ab7d3384c138748a13ed9f7e1df7361a6"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1
  head "https://github.com/symless/synergy.git", branch: "master"

  # This repository contains old 2.0.0 tags, one of which uses a stable tag
  # format (`v2.0.0-stable`), despite being marked as "pre-release" on GitHub.
  # The `GithubLatest` strategy is used to avoid these old tags without having
  # to worry about missing a new 2.0.0 version in the future.
  livecheck do
    url :stable
    regex(/[^"' >]*?v?(\d+(?:\.\d+)+)[^"' >]*?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c1ab802ff146a1a572907710c609b058ae23d3d70f343ca907bc18406a8acd6b"
    sha256 cellar: :any, arm64_tahoe:       "770c9b61bb90763e90eca4b4cdf65d803d97a5becf77fba77ccc949a636c3c2b"
    sha256 cellar: :any, arm64_sequoia:     "fa5b3ee65abe63236ee4f0b0a1ee99e5e41f19d75b975f71f31b18f0f984c49e"
    sha256 cellar: :any, arm64_linux:       "5498fa08d7cfcd8c96cacae311dda8cedb11e92ab1e02a387b85c9e90a42a400"
    sha256 cellar: :any, x86_64_linux:      "9b1d6d2f72c1a5f5aca1537d0d496d86c65d3990767d2ac3666f08ef45164203"
  end

  depends_on "cmake" => :build
  depends_on "qttools" => :build
  depends_on "openssl@4"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1402
    depends_on "qttranslations" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
  end

  fails_with :clang do
    build 1402
    cause "needs `std::ranges::find`"
  end

  def install
    # Avoid statically linking OpenSSL on macOS
    inreplace "src/lib/net/CMakeLists.txt", "set(OPENSSL_USE_STATIC_LIBS TRUE)", ""

    # Release builds now require a serial key in the GUI by default; keep it keyless like 1.20
    args = %w[
      -DBUILD_TESTS:BOOL=OFF
      -DSYNERGY_VERSION_RELEASE=ON
      -DSYNERGY_ENABLE_ACTIVATION=OFF
    ]
    if OS.mac?
      # Skip macdeployqt, which copies Qt dylibs into the app bundle
      args << "-DDEPLOYQT=/usr/bin/true"
      # The bundle's Qt translations are looked up in the qttools prefix
      args << "-D_QT_QM_FILE=#{Formula["qttranslations"].opt_share}/qt/translations/qtbase_en.qm"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      bin.install_symlink prefix/"Synergy.app/Contents/MacOS/Synergy" => "synergy"
      bin.install_symlink prefix/"Synergy.app/Contents/MacOS/synergy-core"
    end
  end

  service do
    run [opt_bin/"synergy"]
    run_type :immediate
  end

  def caveats
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading synergy-core.
    on_macos do
      <<~EOS
        Synergy requires the 'Accessibility' permission for:
          #{opt_prefix}/Synergy.app
        You can grant this permission by navigating to:
          System Preferences -> Security & Privacy -> Privacy -> Accessibility

        If Synergy still doesn't work, try clearing the 'Accessibility' list:
          sudo tccutil reset Accessibility
        You can then grant the 'Accessibility' permission again.
        You may need to clear this list each time you upgrade synergy-core.
      EOS
    end
  end

  test do
    # Linux CI has no display for the default xcb platform plugin
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?

    assert_match "synergy-core v#{version.major_minor_patch}, protocol v",
                 shell_output("#{bin}/synergy-core --version")
    assert_match "synergy-core: failed to load config", shell_output("#{bin}/synergy-core server 2>&1", 4)
  end
end
