class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.4.tar.gz"
  sha256 "6012301d8708c80702976930988b36c40a2d2194bf6a0398762dd080372f7fec"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44d00508966f1f1fd5af82df20bda0454dd2b548fb523c9bab76f1b64b649faa" => :sierra
    sha256 "918944db57ab256090519ccc01c438d8c155c845ecbe17a229f26aa4f89b73e6" => :el_capitan
    sha256 "76553475bbd0e302f140ce18bf768a882c2b1dbf47b4b30670767cf021405783" => :yosemite
    sha256 "7d24f1d903daaf3bda4cfa84f97fca6e5cbdf8e630d0b235671a625062053507" => :mavericks
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
