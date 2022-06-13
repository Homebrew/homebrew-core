class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"

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

  stable do
    url "https://github.com/symless/synergy-core/archive/refs/tags/v1.14.4.37-stable.tar.gz"
    sha256 "081735f032a2909c65322d43bcaf463bca05f88a05882c706762c959cd4bbec6"
  end

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
    sha256                               arm64_monterey: "93130d9add2ff477b7ab848e0f4b4336031ca0ff50dddc2b67cfaef51040bd56"
    sha256                               arm64_big_sur:  "5d3fab34b90a58e079012cc8d2b7f441ad098214161d83894558177b356ed2ed"
    sha256                               monterey:       "2fcafb9115be3180db650acf09ba588ebfadb9c0f8c4a0ecde4d56f9df458206"
    sha256                               big_sur:        "ea0c6b24239d0e24a28cc5a8668cf85b956f3d4d2f43d0102c5a43742a07d49b"
    sha256                               catalina:       "f1666f47106ce89f7607d0e24ed2dd9d1d5d3ac0dce72357ff81c0f4b55612ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbab7cd07ce0f831b70812149aba63de79a8ab7cf998396e44742065249082b6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pugixml"
  depends_on "qt@5"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc" # For C++17 support.
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
