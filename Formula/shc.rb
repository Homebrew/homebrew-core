class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/4.0.1.tar.gz"
  sha256 "494666df8b28069a7d73b89f79919bdc04e929a176746c98c3544a639978ba52"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f6fb1ef4f5f3017438b6a77506c5736a6ab2db30faaa00dbdeb45e4e8d1710" => :mojave
    sha256 "a6e168088060e10e7833309922139274a92e8940c6c81742a4ea9e09ea342b91" => :high_sierra
    sha256 "3c56f17da02fb9462783538cf46fb52e659906004c38c2bbd5c56579b987d837" => :sierra
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
