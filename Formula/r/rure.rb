class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.11.3.tar.gz"
  sha256 "df1a6ec1a1c9404716176acb969d254febb84bb0897e3e79bb475488e9613ce5"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "648ca5379fb0e68d5e5d9340df453a47c884693c5ca4b7982dd5ef44990feaa1"
    sha256 cellar: :any,                 arm64_sequoia: "0d7551fcdaa6dc28a11d39de255c0b8501b17579cf3f7d3d8212f79337179ed3"
    sha256 cellar: :any,                 arm64_sonoma:  "af65868a8461dc49e22073f2807a81e078d7ce1a3139d110226792e467902bb5"
    sha256 cellar: :any,                 sonoma:        "fca3c8f859aa3918f6a9968c7360244799d780771b837b98009736e7dac9459c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b549088cb0e05ddc34d049c79c9533a1755bd6d5d33a4b988ca3dbc728bda88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02b49f5de1163883ba630423f7b058407122d2393b27327efcdd2ff2b1ebdd52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
