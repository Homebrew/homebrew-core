class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  stable do
    url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.9.tar.gz"
    sha256 "53f428e2d9bbdf30e53b06c9c42def9a13ff82fc36a111d410fc8b0bc889ee2d"
    depends_on maximum_macos: [:sequoia, :build] # Remove in 9.4.0
  end

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "40236da144dd4723d91872920d988b7f52e29688745a6be1872cfc5177c965f2"
    sha256 arm64_sonoma:  "318ffb0fb2d334b6f49ce3293aea1c2a6d93e9bf8cf0d103c1e401b55148f84f"
    sha256 arm64_ventura: "924cd93f4e48a4026c5bc64b579e2628147aaadea3bae259d721cb8af203273b"
    sha256 sonoma:        "e80c89d844a75e37d381df5eddbcc6c3080d1f0f8923a6e3a1697443d8354aaf"
    sha256 ventura:       "002b9b8eb714101e13ebeaa3daee81536dd3ae299f8b5ad021abcbcdf3f3c12b"
    sha256 arm64_linux:   "cc5f0996cad11a2893cd832b5496c30ca3162e0ded4cf6423afddce74c26599c"
    sha256 x86_64_linux:  "f2afbf413d542dcaeaf05cec448d97385f4de763f56a3747250ce7908a43b36e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
    ]
    if OS.mac?
      macosx_dependencies_from = case HOMEBREW_PREFIX.to_s
      when "/usr/local"
        "HomebrewLocal"
      when "/opt/homebrew"
        "HomebrewOpt"
      else
        HOMEBREW_PREFIX
      end
      args << "-DMACOSX_DEPENDENCIES_FROM=#{macosx_dependencies_from}"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~PROLOG
      test :-
          write('Homebrew').
    PROLOG
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
