class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "f340cf6ef4762dfc7b0e04d4d0dae542db7f6fb9b9aba4eaf786446047cdb1c4"

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
    sha256                               arm64_tahoe:   "26678afbc7418065590ef6fa576ec661380275169ce64eb9b1243370844876a2"
    sha256                               arm64_sequoia: "e3e3008c7e703c0db1d038bd27645f9479178fe14236bb16edc4960c6b27d21e"
    sha256                               arm64_sonoma:  "8fbba2a9c2af13c41475ab2476be8020398b08962427224ee8608b7cfd0d4975"
    sha256                               sonoma:        "36fcf36037acfd38774c2ec90b6d5dc213ba82fb34a8a0105c5bc0e84237c88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ac1cfccaafcc11cf0eb10836285efbb7a21a9d4c8a5e382bf97799056e8ce5"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pugixml"
  depends_on "qt"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1402
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "libnotify"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
  end

  fails_with :clang do
    build 1402
    cause "needs `std::ranges::find`"
  end

  resource "synergy-extra" do
    url "https://github.com/symless/synergy-extra.git",
        revision: "e68812d06139df5b836f361047a68f8c86efac17"

    # Version.cmake in `synergy-extra` reads .git folder of `synergy`.
    # but it's submodule uses ssh protocol which will be failed in CI
    # and so we use tarball of `synergy` and apply patch to ignore git process
    patch :DATA
  end

  def install
    mkdir_p buildpath/"ext/synergy-extra"
    (buildpath/"ext/synergy-extra").install resource("synergy-extra")

    if OS.mac?
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1402
      # Disable macdeployqt to prevent copying dylibs.
      inreplace "src/gui/CMakeLists.txt",
                /"execute_process\(COMMAND \${MACDEPLOYQT_CMD}.*\)"/,
                '"MESSAGE (\\"Skipping macdeployqt in Homebrew\\")"'
    elsif OS.linux?
      # Get rid of hardcoded installation path.
      inreplace "cmake/Packaging.cmake", "set(CMAKE_INSTALL_PREFIX /usr)", ""
    end

    args = %w[
      -DBUILD_TESTS:BOOL=OFF
      -DCMAKE_INSTALL_DO_STRIP=1
      -DSYSTEM_PUGIXML:BOOL=ON
      -DSYNERGY_VERSION_RELEASE=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install buildpath/"build/bundle"
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy" # main GUI program
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy-server" # server
      bin.install_symlink prefix/"bundle/Synergy.app/Contents/MacOS/synergy-client" # client
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
      # On ARM, macOS is even more picky when dealing with applications not signed
      # by a trusted certificate, and, for whatever reason, both the app bundle and
      # the actual executable binary need to be granted the permission by the user.
      # (On Intel macOS, only the app bundle needs to be granted the permission.)
      #
      # This is particularly unfortunate because the operating system will prompt
      # the user to grant the permission to the app bundle, but will *not* prompt
      # the user to grant the permission to the executable binary, even though the
      # application will not actually work without doing both. Hence, this caveat
      # message is important.
      on_arm do
        s += "\n" + <<~EOS
          On ARM macOS machines, the 'Accessibility' permission must be granted to
          both of the following two items:
            (1) #{opt_prefix}/bundle/Synergy.app
            (2) #{opt_bin}/synergy
        EOS
      end
    end
    s
  end

  test do
    version_string = version.major_minor_patch.to_s
    assert_match(/synergy-server v#{version_string}.*, protocol v/,
                 shell_output("#{opt_bin}/synergy-server --version"))
    assert_match(/synergy-client v#{version_string}.*, protocol v/,
                 shell_output("#{opt_bin}/synergy-client --version"))

    assert_match "synergy-server: failed to load config",
                 shell_output("#{opt_bin}/synergy-server 2>&1", 4)
    assert_match "synergy-client: a server address or name is required",
                 shell_output("#{opt_bin}/synergy-client 2>&1", 3)
  end
end

__END__
diff --git a/cmake/Version.cmake b/cmake/Version.cmake
index 0ea44d0..392f6a0 100644
--- a/cmake/Version.cmake
+++ b/cmake/Version.cmake
@@ -51,36 +51,6 @@ function(version_from_git_tags VERSION VERSION_MAJOR VERSION_MINOR VERSION_PATCH
   set(minor_match "${CMAKE_MATCH_2}")
   set(patch_match "${CMAKE_MATCH_3}")
 
-  set(git_path "${CMAKE_CURRENT_SOURCE_DIR}/.git")
-  if(NOT EXISTS ${git_path})
-    message(FATAL_ERROR "Not a Git repository: ${git_path}")
-  endif()
-  
-  find_package(Git)
-  if(NOT GIT_FOUND)
-    message(FATAL_ERROR "Git not found")
-  endif()
-  message(VERBOSE "Git repo: " ${CMAKE_CURRENT_SOURCE_DIR})
-
-  # Creating a release tag through the GitHub UI creates a lightweight tag, so use --tags
-  # to include lightweight tags in the search.
-  execute_process(
-    COMMAND ${GIT_EXECUTABLE} describe origin/master --tags --long --match "v[0-9]*"
-    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
-    OUTPUT_VARIABLE git_describe
-    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
-  )
-  if (NOT git_describe)
-    message(FATAL_ERROR "No version tags found in the Git repository")
-  endif()
-  message(VERBOSE "Git describe: " ${git_describe})
-
-  string(REGEX REPLACE ".*-([0-9]+)-g.*" "\\1" rev_count ${git_describe})
-  if ("${rev_count}" STREQUAL "")
-    message(FATAL_ERROR "No revision count found in Git describe output")
-  endif()
-  message(VERBOSE "Changes since last tag: " ${rev_count})
-
   if (SYNERGY_VERSION_RELEASE)
     
     message(VERBOSE "Version is release")
