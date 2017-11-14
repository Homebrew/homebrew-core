class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag => "3.4.7",
      :revision => "a839dfa14c81c6e772eb08cfd5ea2941315b984d"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "ba705fbf5f4f66d138ed259a082c18f844275072cffae4b36b9e9cfdb8b0c571" => :high_sierra
    sha256 "3e29026d54b0f6df1d1db291ddf8cd13bb434edc8c7c501d01d6215aa2a24e7b" => :sierra
    sha256 "ef2bb0fed81ef08388a9756f7fefa06a7b08603a28dd909ec2b7dd41ced04bb7" => :el_capitan
    sha256 "f6b86ab2272e40fa98d71fc7d95daa9f504fb779af6544ad8017ad8091113161" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sassc --style compressed input.scss").strip
  end
end
