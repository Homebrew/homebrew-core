class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://xxhash.com"
  url "https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "5738270935e7c3d38a79b3adf7c9692566ce7895a25f67de43ad52ab504acd32"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8fadb24f4ee2177c8763b1d454dda05c26787af9aeacef31d79f622d6c283471"
    sha256 cellar: :any, arm64_tahoe:       "4378420ce577ea0fbffbac3c97f9bbf8d862ff85bc2aecd81b2d87aeec82e51e"
    sha256 cellar: :any, arm64_sequoia:     "11fa633824f0462f584909a90b3231d4bd18c6735addfd154ffff06b0c0f039c"
    sha256 cellar: :any, arm64_linux:       "5129b758780c883c989048cc8fb2b52859ab00c9f020fd766b535efc56dbcb7a"
    sha256 cellar: :any, x86_64_linux:      "64866e1f4d8bf1c49e7883592290d186d47b2d3b3ce434ffc73364f534275ae6"
  end

  depends_on "cmake" => [:build, :test]

  deny_network_access!

  def install
    ENV.O3

    args = ["PREFIX=#{prefix}"]
    if Hardware::CPU.intel?
      args << "DISPATCH=1"
      ENV.runtime_cpu_detection
    end

    system "make", "install", *args
    prefix.install "cli/COPYING"

    # We use CMake for package configuration files which are needed by `manticoresearch`.
    # The Makefile is used for everything else as it is the only officially supported way.
    ENV["DESTDIR"] = buildpath
    system "cmake", "-S", "build/cmake", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build" # needed to run `--install` which rewrites build path in .cmake file
    system "cmake", "--install", "_build"
    lib.install File.join(buildpath, lib, "cmake")
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))

    # Simplified snippet of https://github.com/Cyan4973/xxHash/blob/dev/cli/xsum_sanity_check.c
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdint.h>
      #include <xxhash.h>

      int main() {
        size_t len = 0;
        uint64_t seed = 2654435761U;
        uint64_t Nresult = 0xAC75FDA2929B17EFULL;

        XXH64_state_t *state = XXH64_createState();
        assert(state != NULL);
        assert(XXH64(NULL, len, seed) == Nresult);
        XXH64_freeState(state);
        return 0;
      }
    C

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES C)
      find_package(xxHash CONFIG REQUIRED)
      add_executable(test test.c)
      target_link_libraries(test PRIVATE xxHash::xxhash)
    CMAKE

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
