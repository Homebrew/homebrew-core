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
    sha256 cellar: :any, arm64_golden_gate: "206543de543008dd31c3725f746a02a397b998154d153506a68f3046daff288c"
    sha256 cellar: :any, arm64_tahoe:       "8aad19e0da49e4d7283d9443629a4a30d179955409268fcbe5b373238d53960d"
    sha256 cellar: :any, arm64_sequoia:     "8a6d7afafb04f52e7992711d1ee7e8d060f2a3b940163e827f2ec87978dff417"
    sha256 cellar: :any, arm64_linux:       "5f78a812090c0a41721a8bb32b644b6ea85f3df71beb6dfe44daf63e180fc81a"
    sha256 cellar: :any, x86_64_linux:      "82438dcfe467ce26a5c17dcdbe3de64e7cab24780fd847c539c27b8d18598b32"
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
