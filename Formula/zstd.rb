class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.1.0.tar.gz"
  sha256 "61cbbd28ff78f658f0564c2ccc206ac1ac6abe7f2c65c9afdca74584a104ea51"

  bottle do
    cellar :any
    sha256 "c36a722a385d79011020535b89d7320bce517a5399d0390bc55229446cc12c1b" => :sierra
    sha256 "6e4b8bc31e97490ce4735c5e6029f38867bd1e8b11a3cef4ba50ecdf684234bb" => :el_capitan
    sha256 "21635898db441c5389c52d139a46655fcca2f495f3dfd09c9044f1062954ff74" => :yosemite
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    if build.with? "pzstd"
      system "make", "-C", "contrib/pzstd/", "PREFIX=#{prefix}/"
      bin.install "contrib/pzstd/pzstd"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    if build.with? "pzstd"
      assert_equal "hello\n",
        pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
    end
  end
end
