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
    rebuild 1
    sha256                               arm64_sonoma:   "8e21d500ed1567182b5b123a76f6e576a39b09c773ede9612cd11626e57a13fd"
    sha256                               arm64_ventura:  "4b21f477ede4756031bcebf1acb32542d0602c12afd1b2087774ea4cf6ad0bcd"
    sha256                               arm64_monterey: "101739d8739aa9b5de4d17f7ce4fc1f4922928c155b740fc3391e9b57838418e"
    sha256                               sonoma:         "b8481a8fc33f66b7819ea6aa2fd00683db248742b4e271f55352371e1d1c9de3"
    sha256                               ventura:        "e4ccf938d38c07196b39c59f71feb422c1a950ce1dea9b5577aac062580a87f1"
    sha256                               monterey:       "7e18aa9801410561452da1503ee9e0a7b987086ff4f2603bb4bce7bf9c4fc4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b80be1af6d257aea32a7c8533fd7e7254832f6c05a2e706633e39a81e096a6b"
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

    # Disable macdeployqt to prevent copying dylibs
    inreplace "src/gui/CMakeLists.txt",
              /"execute_process\(COMMAND \${MACDEPLOYQT_EXECUTABLE}.*\)"\)$/,
              '"MESSAGE (\\"Skipping macdeployqt in Homebrew\\")")'

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
