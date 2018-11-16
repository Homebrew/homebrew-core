class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.8.tar.gz"
  sha256 "8b31e1f2ceef3404217b9578fa250a8a424f3eaf03359dd7951cd635c889ad79"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "447c100eff8a2ea169d4415344b3835dced439a91bc0ab322be01e97886ecc54" => :mojave
    sha256 "733638c58c4638ae63dedbcd35ebef1bb20365c74978f7bdbb3059a7a1039e34" => :high_sierra
    sha256 "f7c53fd5fa9c86057260ad66961406b4579738b30091d7ca6899eb5349013b0c" => :sierra
    sha256 "c54ddaec872f8c3613c53f7b1653250f3a11ad6db789418f8921be96fff6e8a3" => :el_capitan
    sha256 "0b40ee06c9a5db74e302be41adea362975bf86c9c5e6290da13a623341e4468d" => :yosemite
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
