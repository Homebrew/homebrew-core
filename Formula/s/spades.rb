class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://github.com/ablab/spades"
  license "GPL-2.0-only"

  # TODO: Remove stable dependencies and fails_with in the next release.
  # Instead, the head dependencies should be used everywhere.
  stable do
    url "https://github.com/ablab/spades/releases/download/v3.15.5/SPAdes-3.15.5.tar.gz"
    sha256 "155c3640d571f2e7b19a05031d1fd0d19bd82df785d38870fb93bd241b12bbfa"

    depends_on "python-setuptools"

    on_macos do
      depends_on "gcc"
    end

    fails_with :clang do
      cause "fails to link with recent `libomp`"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 sonoma:       "fe9990fdd0a2aed4be9ae1b409ec9ce7624fb67cecdaf9a93dc7a27e79a5d44b"
    sha256 cellar: :any,                 ventura:      "7937876005faaaf6721f9aa34a38eaf46559863660b8a80f610cce1ab82e9eef"
    sha256 cellar: :any,                 monterey:     "c81b55304bedd35d5b1959ab650f0d005d3fee2eadf6795fc3d69b3c5a4539b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3889b1e2c9a0a3f08f9e478cf370e078524fd2155150af7431866f4fca7c0557"
  end

  head do
    url "https://github.com/ablab/spades.git", branch: "next"

    on_macos do
      depends_on "libomp"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
