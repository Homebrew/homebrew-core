class Zimpl < Formula
  desc "Mathematical modeling language for optimization problems"
  homepage "https://github.com/scipopt/zimpl"
  url "https://github.com/scipopt/zimpl/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "95f24de663321a86d2cdef28e085f23d7604086e7bd4218782353b2e65d943bc"
  license "LGPL-3.0-or-later"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  depends_on "gmp"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # example from p. 4 of ZIMPL User Guide
    (testpath/"test.zpl").write <<~EOS
      set V :={"a","b","s","t"};
      set A :={<"s","a">, <"s","b">, <"a","b">, <"a","t">, <"b","t">};
      param c[A] := <"s","a"> 17, <"s","b"> 47, <"a","b"> 19, <"a","t"> 53,
      <"b","t"> 23;
      defset dminus(v) := {<i,v> in A};
      defset dplus(v) := {<v,j> in A};
      var x[A] binary;
      minimize cost: sum<i,j> in A: c[i,j] * x[i,j];
      subto fc:
      forall <v> in V - {"s","t"}:
      sum<i,v> in dminus(v): x[i,v] == sum<v,i> in dplus(v): x[v,i];
      subto uf:
      sum<s,i> in dplus("s"): x[s,i] == 1;
    EOS

    system bin/"zimpl", "test.zpl"
    assert_path_exists testpath/"test.lp"
    assert_path_exists testpath/"test.tbl"
  end
end
