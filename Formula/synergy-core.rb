class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core/archive/refs/tags/1.14.5.17.tar.gz"
  sha256 "ed48717ad664773aa3492e34f085873cab43fb84e8fe3717db485588b67ae1d1"

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
    regex(%r{href=["']?[^"' >]*?/tag/[^"' >]*?v?(\d+(?:\.\d+)+)[^"' >]*?["' >]}i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "0e2dfd4b2c992c6953470239b08c15136eb113a476a4553a55021ba9048ede1b"
    sha256                               arm64_big_sur:  "2828370ddc9ba0466e78773e39051f379ee95a4e6d7b6e2fa4934fbe5c241898"
    sha256                               monterey:       "7513faa923880772e8209c5b729c112e4a49c200d65597882c156c11008c2dbe"
    sha256                               big_sur:        "e82a5ded88d0c0f9d11f5026b1bd7c0c7c98906f4c5e683edee8feb70396c6fc"
    sha256                               catalina:       "66bb64c4ac31a93d1c1fe231ee27ef10d2617da8ce2082e761f2e28e894ac87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd939f3ad2f9ece9d70c4550be88322a64abdf49e8574b9afb610e696f2f1314"
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
    assert_match(/synergys #{version_string}[\-.0-9a-z]*, protocol version/,
                 shell_output("#{opt_bin}/synergys --version", 3).lines.first)
    assert_match(/synergyc #{version_string}[\-.0-9a-z]*, protocol version/,
                 shell_output("#{opt_bin}/synergyc --version", 3).lines.first)
  end
end
