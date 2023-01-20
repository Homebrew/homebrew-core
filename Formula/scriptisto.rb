class Scriptisto < Formula
  desc "Language-agnostic \"shebang interpreter\" to write scripts in compiled languages"
  homepage "https://github.com/igor-petruk/scriptisto"
  url "https://github.com/igor-petruk/scriptisto/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "893a06d5349d2462682021f1e053488b07a608eee138dfcc9e68853223d48b81"
  license "Apache-2.0"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #!/usr/bin/env scriptisto

      // scriptisto-begin
      // script_src: main.c
      // build_cmd: cc -O2 main.c -o ./script
      // scriptisto-end

      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("scriptisto ./hello-c.c")
  end
end
