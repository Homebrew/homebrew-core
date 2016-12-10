class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.4.0", :revision => "3c0c0efbb4bd45319683c08aa95d5753aea1c663"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "ba9da004cd7aceda6760e530cad28918b20bf6ca1e3592871232f33a39aef71e" => :sierra
    sha256 "4023cdeae0b3e8b6d1d9b5309935e7d2be1219a7dfd3fabec6e1b13837e59e80" => :el_capitan
    sha256 "63d54a456447cef69725486efa0bd922d6517cc132a67054edf12dce2e8f5ed8" => :yosemite
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
    (testpath/"input.scss").write <<-EOS.undent
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
