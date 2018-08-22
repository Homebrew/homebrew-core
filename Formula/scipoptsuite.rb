class Scipoptsuite < Formula
  desc "Solving Constraint Integer Programs"
  homepage "http://scip.zib.de/"
  url "http://scip.zib.de/download/release/scipoptsuite-6.0.0.tgz"

  sha256 "a91119687e521575070c43eaa30bc15ce461e9dc414651793ea4c4ca33b89750"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "readline"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DSHARED=on
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scip", "--version"
  end
end
