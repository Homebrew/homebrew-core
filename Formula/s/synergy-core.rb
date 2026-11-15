class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "c80a1bc6c0e40fe60e8614e88e988d34ccf5a04b57d3560de946989282d526c9"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "21a13214c2e342729826c304cec3a1a2972315c0af7cbeca78e5011ccb5060f3"
    sha256 cellar: :any, arm64_tahoe:       "58f8adf056ec963b144e7ae68d764423f4b5a42fae6a75a572d216143f577daf"
    sha256 cellar: :any, arm64_sequoia:     "7a6895a7dd8fcdb78ad1e33ec46091e546e319aff50743dcd39cb0152de206b9"
    sha256 cellar: :any, arm64_linux:       "07007e3721635b03b0e9e2577782327e4c0589006307db6d4a71175ada0d0387"
    sha256 cellar: :any, x86_64_linux:      "b4a7916ce6bdec0b9db009ed39786cf08012b9ef7312b210cb7647a8c064efa5"
  end

  # Upstream replaced the source repository with a signpost: https://github.com/symless/synergy
  deprecate! date: "2026-10-25", because: :repo_removed
  disable! date: "2027-10-25", because: :repo_removed

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

  allow_network_access! :test

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

    assert_match version.to_s, shell_output("#{bin}/synergy-core --version")
    assert_match "synergy-core: failed to load config", shell_output("#{bin}/synergy-core server 2>&1", 4)
  end
end
