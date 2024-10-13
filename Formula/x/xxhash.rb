class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://xxhash.com"
  url "https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "ae616166bfea73b6f037c648a4cb84b33a64ec91d9c4edd149ac2b83585b3573"
    sha256 cellar: :any,                 arm64_sonoma:   "ae0ac26ed3379dff86fcd2f34f70a927a44bfedad87c2f2d46723b45cfa5bfe5"
    sha256 cellar: :any,                 arm64_ventura:  "2d0df15d11a6f3f5786b78ad8dc97092f73f915f7b65790d7bb18e54407d43ba"
    sha256 cellar: :any,                 arm64_monterey: "db3ffe16e74cf1cf2564f281553f64b5188f56b9630c371fbaed1d93a800150b"
    sha256 cellar: :any,                 sonoma:         "7ca0782ca1dc2a866db27d4d2c0239a72dd8970c1d7bca0a5468572197d2c50b"
    sha256 cellar: :any,                 ventura:        "c2336943469780a2f33257e4a782e65ff9436d6bba2ccf4dfd4f65aed9c6b225"
    sha256 cellar: :any,                 monterey:       "f02d5450fdb357f4b61bd319aa514f32065409bf5b67eb64eadc123a89eb44ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87b4144350b4eb01586efffff599159b7d36b1100429633156b392fefbe9997"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES C)
      find_package(xxHash CONFIG REQUIRED)
      add_executable(test test.c)
      target_link_libraries(test PRIVATE xxHash::xxhash)
    EOS
    system "cmake", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
