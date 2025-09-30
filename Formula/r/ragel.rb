class Ragel < Formula
  desc "State machine compiler"
  homepage "https://www.colm.net/open-source/ragel/"
  url "https://www.colm.net/files/ragel/ragel-6.10.tar.gz"
  sha256 "5f156edb65d20b856d638dd9ee2dfb43285914d9aa2b6ec779dac0270cd56c3f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/Stable.*?href=.*?ragel[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a861e1645f5b8f830a41c21217ff8423360dcc678bd5f25648f3737e75e3f0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2bbe81eb822afe87192cd8b4688fe5bb9f84b2fe87ea343ef0155ff8b6590ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ee07f4d272aeaa30c28763be68741670e7e38c518e49fc9c214db1cdfa717d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a023336bcea614167bc5f77ed303c53e2d26319057c835f0d49c841895515a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4427818a8647c06fe09fffa1960f6fbf4ce2c10dee048b1880486390c151585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "858ef57e50114e0406d7afc3beb7c06462bc1b5ce2155948af84af0c41d739f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5771ddc6f4f2930842f90d27dd598a70fe35a0b8d0961dd67cf96fa5f1280f42"
    sha256 cellar: :any_skip_relocation, ventura:        "389f08b69edbc2fd8d9f79351549d31d2509e660c595c94e8e170432a4ba3d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe77eea34f4c9d9cc26f94706f55a3b38a595c9fb334fc0d3c168ea7abbf5b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "712245a75110f6628e7c07130d2905577f1a533bf760692e0f4b3071df20cc40"
    sha256 cellar: :any_skip_relocation, catalina:       "a402204e97c35c6a9487d2b0707e27766d9b39c9c2116d49e9c561e1d0bd54b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1273e5876162710bb47f6c16ec99b755035cb171d3b5d32be4e362ae7a3d08e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2306dd1c44d304bc0e86093e9f87e0e885d0d9ce03579ab55d7a6c9bf2ada95b"
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
    testfile.write <<~EOS
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
