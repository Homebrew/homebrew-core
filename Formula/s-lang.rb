class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2"
  mirror "https://src.fedoraproject.org/repo/pkgs/slang/slang-2.3.2.tar.bz2/sha512/35cdfe8af66dac62ee89cca60fa87ddbd02cae63b30d5c0e3786e77b1893c45697ace4ac7e82d9832b8a9ac342560bc35997674846c5022341481013e76f74b5/slang-2.3.2.tar.bz2"
  sha256 "fc9e3b0fc4f67c3c1f6d43c90c16a5c42d117b8e28457c5b46831b8b5d3ae31a"

  bottle do
    rebuild 1
    sha256 "862f29d0ec2a550cfe2fcb3b636de4b6251be184ce468f4a42bbce03f5dfcd05" => :mojave
    sha256 "d1e3b31d585951f3b7eddd49242573ddd17b7fb15e295e3c987497fc02fbf9c2" => :high_sierra
    sha256 "587a25f8189a6579e730b9cf5bed62feb55381a66aae4d5fddfb59dfc6868802" => :sierra
    sha256 "a57f80593cc9b57b7c7eef8252a81b0240b9c421fac756010e01c5292f51bff1" => :el_capitan
  end

  depends_on "libpng"

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
