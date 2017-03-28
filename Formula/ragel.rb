class Ragel < Formula
  desc "State machine compiler"
  homepage "https://www.colm.net/open-source/ragel/"
  url "https://www.colm.net/files/ragel/ragel-6.10.tar.gz"
  sha256 "5f156edb65d20b856d638dd9ee2dfb43285914d9aa2b6ec779dac0270cd56c3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eb25a7a2a9c024a74d005325de607a9706206427a1cda7b761aae92d4cf771b" => :sierra
    sha256 "7069ccbc6474e60eda037327a987329e6546e6ebcebd67cd851d9a530799fb14" => :el_capitan
    sha256 "0d7df494b183973c51cc1f8f3085924da718598661388c7065e5f8ead2f5c4ac" => :yosemite
    sha256 "0a086aa5126b989c3b40c0c3568f496803a66e612c61f938171addb8c06626e7" => :mavericks
  end

  resource "pdf" do
    url "https://www.colm.net/files/ragel/ragel-guide-6.10.pdf"
    sha256 "efa9cf3163640e1340157c497db03feb4bc67d918fc34bc5b28b32e57e5d3a4e"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    doc.install resource("pdf")
  end

  test do
    testfile = testpath/"rubytest.rl"
    testfile.write <<-EOS.undent
    %%{
      machine homebrew_test;
      main := ( 'h' @ { puts "homebrew" }
              | 't' @ { puts "test" }
              )*;
    }%%
      data = 'ht'
      %% write data;
      %% write init;
      %% write exec;
    EOS
    system bin/"ragel", "-Rs", testfile
  end
end
