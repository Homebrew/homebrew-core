class Scriptisto < Formula
  desc "Language-agnostic \"shebang interpreter\" to write scripts in compiled languages"
  homepage "https://github.com/igor-petruk/scriptisto"
  url "https://github.com/igor-petruk/scriptisto/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "893a06d5349d2462682021f1e053488b07a608eee138dfcc9e68853223d48b81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5ebbf7af4d2b00e8ab3096dca55dbe031c74f7e59dcf06421584dcd851a5862"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad843e920b8bb4abdb8ab53120952c9e9c4dd63a1dafcc599daa102e55cf12e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e945e6fd4037fdd52d72c34ca383be631b5a3bb87dad4e9165b63590b272d91"
    sha256 cellar: :any_skip_relocation, ventura:        "0a36cd8392e6db538f39381d08757d2b1618cab7471029508b8dd40aed35579b"
    sha256 cellar: :any_skip_relocation, monterey:       "43e6db419727d10fe03742a11f9cdf998f0ce09cec9906b1989f9fd8a7f74b0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1a452e563ab6946bca6be8666bb793ba34255c690243cc4cdcd4aa9a6646d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f409e45a80582afc370744deed2477ce3f222b35edd485d10105fcfaffafde"
  end

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
    assert_equal "Hello, world!\n", shell_output("#{bin}/scriptisto ./hello-c.c")
  end
end
