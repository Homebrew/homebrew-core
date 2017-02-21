class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v1.1.0/ringojs-1.1.0.tar.gz"
  sha256 "2da497a3850a628b0c060474be55d575c3576ad08c314beca30ab91d5aea6bd2"

  bottle :unneeded

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
        var x = 40 + 2;
        console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end
