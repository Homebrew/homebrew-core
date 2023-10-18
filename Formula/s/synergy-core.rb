class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core/archive/refs/tags/1.14.6.19-stable.tar.gz"
  sha256 "01854ec932845975cd81363bed8276b95c07a607050683fc1b74b7126199de79"

  # The synergy-core/LICENSE file contains the following preamble:
  #   This program is released under the GPL with the additional exemption
  #   that compiling, linking, and/or using OpenSSL is allowed.
  # This preamble is followed by the text of the GPL-2.0.
  #
  # The synergy-core license is a free software license but it cannot be
  # represented with the brew `license` statement.
  #
  # The GitHub Licenses API incorrectly says that this project is licensed
  # strictly under GPLv2 (rather than GPLv2 plus a special exception).
  # This requires synergy-core to appear as an exception in:
  #   audit_exceptions/permitted_formula_license_mismatches.json
  # That exception can be removed if the nonfree GitHub Licenses API is fixed.
  license :cannot_represent
  head "https://github.com/symless/synergy-core.git", branch: "master"

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
    sha256                               arm64_sonoma:   "3195be9b2fa3cc164cfa8104fc2a41b51dd8ff1a1173148518320371b4c411e3"
    sha256                               arm64_ventura:  "334248b42a57a1e655f2f4aab7772ea3b7b77ae438cfe42623e84f7583b9174d"
    sha256                               arm64_monterey: "b55b45badf37a0c6ff570dc9bc84c684b42bd4966eea299602c6308c0d3c568b"
    sha256                               arm64_big_sur:  "c8870bbda127a4b699803c45a3de12f823937c5d553219b77fc5a738bb1ec942"
    sha256                               sonoma:         "b0a2d58bf66e485c10cb37d81b5ddd364ccdc36345e8ddef3ee04afd64b8d29d"
    sha256                               ventura:        "a379d665374e700ec3447de68d9f51adc413d2df2b853ebb89d65ea4a83846ba"
    sha256                               monterey:       "f0711f93ccc9180ed973f6c7168b95bc55aa91e2d45116c91e5cf97733802018"
    sha256                               big_sur:        "05274d4b236f2d4e4e0037f3a9738ce1f297e88c5af4983db3efc098e46f0893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f9f6c071c90a720430c7a827ccc6f8bea9c244bf9a71e2f94ad746b6b49892"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pugixml"
  depends_on "qt@5"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "libnotify"
    depends_on "libxkbfile"
  end

  fails_with gcc: "5" do
    cause "synergy-core requires C++17 support"
  end

  def install
    # Use the standard brew installation path.
    inreplace "CMakeLists.txt",
              "set (SYNERGY_BUNDLE_DIR ${CMAKE_BINARY_DIR}/bundle)",
              "set (SYNERGY_BUNDLE_DIR ${CMAKE_INSTALL_PREFIX}/bundle)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_TESTS:BOOL=OFF", "-DCMAKE_INSTALL_DO_STRIP=1",
                    "-DSYSTEM_PUGIXML:BOOL=ON"

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy"  # main GUI program
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergys" # server
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergyc" # client
    end
  end

  service do
    run [opt_bin/"synergy"]
    run_type :immediate
  end

  def caveats
    # Because we used `license :cannot_represent` above, tell the user how to
    # read the license.
    s = <<~EOS
      Read the synergy-core license here:
        #{opt_prefix}/LICENSE
    EOS
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading synergy-core.
    on_macos do
      s += "\n" + <<~EOS
        Synergy requires the 'Accessibility' permission.
        You can grant this permission by navigating to:
          System Preferences -> Security & Privacy -> Privacy -> Accessibility

        If Synergy still doesn't work, try clearing the 'Accessibility' list:
          sudo tccutil reset Accessibility
        You can then grant the 'Accessibility' permission again.
        You may need to clear this list each time you upgrade synergy-core.
      EOS
    end
    s
  end

  test do
    assert_equal shell_output("#{opt_bin}/synergys", 4),
                 "synergys: no configuration available\n"
    assert_equal shell_output("#{opt_bin}/synergyc", 3).split("\n")[0],
                 "synergyc: a server address or name is required"
    return if head?

    version_string = Regexp.quote(version.major_minor_patch)
    assert_match(/synergys #{version_string}[-.0-9a-z]*, protocol version/,
                 shell_output("#{opt_bin}/synergys --version", 3).lines.first)
    assert_match(/synergyc #{version_string}[-.0-9a-z]*, protocol version/,
                 shell_output("#{opt_bin}/synergyc --version", 3).lines.first)
  end
end
