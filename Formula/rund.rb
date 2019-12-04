class Rund < Formula
  desc "Compiler-wrapper that runs and caches D programs"
  homepage "https://github.com/dragon-lang/rund"
  url "https://github.com/dragon-lang/rund/archive/v1.0.0.tar.gz"
  sha256 "25bc01e14f4a3c5151c3f79583e55a1b400b794bfebae460765b75b89ee217ea"

  depends_on "dmd"

  def install
    system "dmd", "-O", "-i", "-I=src", "-run", "make.d", "build"
    bin.install "./bin/rund"
  end

  test do
    (testpath/"test.d").write <<~EOS
      #!/usr/bin/env rund
      import std.stdio: writeln;
      int main() { return 0; }
    EOS
    File.chmod(0777, "test.d")
    system "./test.d"
  end
end
