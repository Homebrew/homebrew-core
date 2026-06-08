class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://xxhash.com"
  url "https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "aae608dfe8213dfd05d909a57718ef82f30722c392344583d3f39050c7f29a80"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60aa4eca9aa378cbaa79fb2ffc0d1b4a142fd32c0aaf7371b09c291530fb85d2"
    sha256 cellar: :any,                 arm64_sequoia: "89bd0369c7033c364428cf03daad6f58ca5e5defd8dc585b8f0bc6a111714013"
    sha256 cellar: :any,                 arm64_sonoma:  "32a8ae9615395368644020266663a1758cd4b32b15cdf8c547c9b5a3a3bc3016"
    sha256 cellar: :any,                 arm64_ventura: "60dfb4150b26f590cb36561262a3bf0d845bacb2e26ec7d4bf5f619be9ddce5a"
    sha256 cellar: :any,                 sonoma:        "e2355ea12831286d6858820e7fedcc3a044904f510ecc47d988698cd629a7ab0"
    sha256 cellar: :any,                 ventura:       "b48f20a3ccf572377aa01bc280f66692e43c94b26d1eac4ac5493ce576c5cd3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f094838a4f796f2314aa813a8e254d6d6582920fef2e0071a9f0c94ce538e350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18dc2081164fec96866d5f6300bde1e3c3a80c0d7659183195e5810a8e438470"
  end

  depends_on "cmake" => [:build, :test]

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
    system "cmake", "-S", "cmake_unofficial", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build" # needed to run `--install` which rewrites build path in .cmake file
    system "cmake", "--install", "build"
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
