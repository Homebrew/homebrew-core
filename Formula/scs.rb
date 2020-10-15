class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/2.1.2.tar.gz"
  sha256 "fa2a959180224e4a470d5e618012b56cf9d04aba9ff23c75117c01a8e3e70234"
  license "MIT"

  bottle do
    cellar :any
    sha256 "c5a8b9e03c06e7eab32e1934e69ebed0036b2ae7a9a98612f4aab618d665db96" => :catalina
    sha256 "2bad6f83534fe6fd7f2f3f4b56ed2c942aa650060090239c458fc3e36c1cea10" => :mojave
    sha256 "3335a0697e50ea6bf1b38ff0f3a8946d8945a25b8c5731f4afe7b59c965c43c0" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/data/small_random_socp"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rw.h>
      #include <scs.h>
      #include <util.h>
      int main() {
        ScsData *data; ScsCone *cone;
        const int status = scs_read_data("#{pkgshare}/small_random_socp",
                                         &data, &cone);
        ScsSolution *solution = scs_calloc(1, sizeof(ScsSolution));
        ScsInfo info;
        const int result = scs(data, cone, solution, &info);
        scs_free_data(data, cone); scs_free_sol(solution);
        return result - SCS_SOLVED;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsindir",
                   "-o", "testscsindir"
    system "./testscsindir"
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsdir",
                   "-o", "testscsdir"
    system "./testscsdir"
  end
end
