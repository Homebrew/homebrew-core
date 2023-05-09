class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core/archive/refs/tags/1.14.6.18-stable.tar.gz"
  sha256 "7f1bbf457f7134ff6110269e63740fb6346660a229adaf1e1bf2f1ee735271c1"

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
    sha256                               arm64_ventura:  "3ec5b29ab967ddba356f47ba10d19bd67b3782ea7d7a2930a5865cace48a273e"
    sha256                               arm64_monterey: "c2c1f0cab39a26359b21dd4d0634e14ff87ea84860acb2c065222b7a1dd3e419"
    sha256                               arm64_big_sur:  "1248f8e053a13f764325db5edab37a9c50a6747495b2708a56c62dee6c702b02"
    sha256                               ventura:        "9fddff02c34fc1b21a245d60ac513b6cda88d904e65aaf44d14fbe38f26339f1"
    sha256                               monterey:       "8d2d76f8808c5f38cc55c2fb1142a9fbc2447daf8f9f7497849cfba9d25c7884"
    sha256                               big_sur:        "6ad5793b1e2077ea952fb1163c9f406a7bb2497a4cb4ecec9af656b6b7f16d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d38c91e320559dc5f6d5cf789cb045afa53e6685001335efdc921d97adb1ee1"
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
