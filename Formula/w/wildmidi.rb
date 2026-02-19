class Wildmidi < Formula
  desc "Simple software midi player"
  homepage "https://github.com/Mindwerks/wildmidi"
  url "https://github.com/Mindwerks/wildmidi/archive/refs/tags/wildmidi-0.4.6.tar.gz"
  sha256 "051b8c51699af594ddd3e4e3b06bad3564e9499c3c6b9e6f880cb2f92bcfa9c8"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fec3c0e1391b9ddce5df2c213ace4a11edf804189f70699e4f333fcd1e642abb"
    sha256 cellar: :any,                 arm64_sequoia:  "bb7178ae28716d1596dc04796b86318c2b96c3d5fc19a013fb63f3755aeccf7f"
    sha256 cellar: :any,                 arm64_sonoma:   "1957eaf82b32edbcd7efb37a209ccd6e2ceee82ec576e29b6d1666fc5e05945b"
    sha256 cellar: :any,                 arm64_ventura:  "5bda39b9e4b7c069bc80baa25a31dba900a78f2cc79f47d798a554e2670fe9e0"
    sha256 cellar: :any,                 arm64_monterey: "6dfb03870142cd1ca7496d24056f3dd6b501bf58c395e270b0261391fcc7ca40"
    sha256 cellar: :any,                 sonoma:         "42a524ea0a68475608e63e99e3d2c975f17c5d79d680fadafd17b371acba84ed"
    sha256 cellar: :any,                 ventura:        "8578920cfff7dc9afb7deecd7397922ebcbd8092cba2bdb55aa830593c56f9de"
    sha256 cellar: :any,                 monterey:       "eb9ba5cb84a6a5105da658c4f3930f0d3d2c22e4caf39790c261912b48b7cc21"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c0e66dee3078f0f1c1fa2c727d2af4194da035eb0fb80e9b8be240fd8665a30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440af3c41c5ff0b321a6508dc0e531e2518cd78bad6b8ba5467ff65c25d5eb73"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <wildmidi_lib.h>
      #include <stdio.h>
      #include <assert.h>
      int main() {
        long version = WildMidi_GetVersion();
        assert(version != 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lWildMidi"
    system "./a.out"
  end
end
