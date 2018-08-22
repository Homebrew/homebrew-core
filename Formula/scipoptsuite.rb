class Scipoptsuite < Formula
  desc "Solving Constraint Integer Programs"
  homepage "http://scip.zib.de/"
  url "http://scip.zib.de/download/release/scipoptsuite-6.0.0.tgz"
  sha256 "a91119687e521575070c43eaa30bc15ce461e9dc414651793ea4c4ca33b89750"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "readline"

  def install
    args = std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.lp").write <<~EOS
      Maximize
       obj: x1 + 2 x2 + 3 x3 + x4
      Subject To
       c1: - x1 + x2 + x3 + 10 x4 <= 20
       c2: x1 - 3 x2 + x3 <= 30
       c3: x2 - 3.5 x4 = 0
      Bounds
       0 <= x1 <= 40
       2 <= x4 <= 3
      General
       x4
      End
    EOS

    system "#{bin}/scip", "-c", "read simple.lp optimize quit"
  end
end
