class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "f80270bcf1dcaaa6e91c39747292428573f99ccf80116a0fee71de145c12b667"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
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
    sha256 cellar: :any,                 arm64_tahoe:   "e87674bec5466e499885db60321faf31aeb0f2cda55f6c20b98cd543381d9b36"
    sha256 cellar: :any,                 arm64_sequoia: "4280ea5122753277d50e8c89a3c0c9ffd3d91946673b650908c75c57c53ccdbf"
    sha256 cellar: :any,                 arm64_sonoma:  "226fd09ebf7df2563fcc96a1033621c4d8a609c4d0efa6b21a6bff129a263e6f"
    sha256 cellar: :any,                 sonoma:        "d3b1e8f60ee0b691159f1503b657ca9146971fe46e6d41663ca8d83717b178d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200dae8d3400f6497dd062c66aad16cb5fe340ed29355bc0909cf6fad1922c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f194ab834cc7168d41bea2007b4df1b0df1fad6a62f5543c35a77553b14a51b7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qtbase"

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
        revision: "5056ed0d4a22e00a4c410733cc0129040de84099"

    # Version.cmake in `synergy-extra` reads .git folder of `synergy`.
    # but it's submodule uses ssh protocol which will be failed in CI
    # and so we use tarball of `synergy` and apply patch to ignore git process
    patch :DATA
  end

  # Fix VERSION file not updated for 1.20.2 release
  # Upstream pr ref, https://github.com/symless/synergy/pull/179
  patch do
    url "https://github.com/symless/synergy/commit/0953f62ba8a98eaa87eee2857efef5f5ef64a87e.patch?full_index=1"
    sha256 "5701a3d18b91458b0e44fb420d362f68e7787da2798d46e42bfd913e62bade38"
  end

  def install
    # Avoid statically linking OpenSSL on macOS
    inreplace "cmake/Libraries.cmake", "set(OPENSSL_USE_STATIC_LIBS TRUE)", ""

    mkdir_p buildpath/"ext/synergy-extra"
    (buildpath/"ext/synergy-extra").install resource("synergy-extra")

    if OS.mac?
      # Disable macdeployqt to prevent copying dylibs.
      inreplace "src/gui/CMakeLists.txt",
                /"execute_process\(COMMAND \${MACDEPLOYQT_CMD}.*\)"/,
                '"MESSAGE (\\"Skipping macdeployqt in Homebrew\\")"'
    end

    args = %w[
      -DBUILD_TESTS:BOOL=OFF
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
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading synergy-core.
    on_macos do
      s = <<~EOS
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
      s
    end
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
