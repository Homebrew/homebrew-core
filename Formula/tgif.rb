class Tgif < Formula
  desc "Xlib-based interactive 2D drawing tool"
  homepage "http://bourbon.usc.edu/tgif/"
  url "https://downloads.sourceforge.net/project/tgif/tgif/4.2.5/tgif-QPL-4.2.5.tar.gz"
  sha256 "2f24e9fecafae6e671739bd80691a06c9d032bdd1973ca164823e72ab1c567ba"

  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.obj").write <<-EOS.undent
      %TGIF 4.2.5
      state(0,37,100.000,0,0,0,16,1,9,1,1,0,0,1,0,1,0,'Courier',0,80640,0,0,0,10,0,0,1,1,0,16,0,0,1,1,1,1,1088,1408,1,0,2880,0).
      %
      % @(#)$Header$
      % %W%
      %
      unit("1 pixel/pixel").
      color_info(11,65535,0,[
        "magenta", 65535, 0, 65535, 65535, 0, 65535, 1,
        "red", 65535, 0, 0, 65535, 0, 0, 1,
        "green", 0, 65535, 0, 0, 65535, 0, 1,
        "blue", 0, 0, 65535, 0, 0, 65535, 1,
        "yellow", 65535, 65535, 0, 65535, 65535, 0, 1,
        "pink", 65535, 49344, 52171, 65535, 49344, 52171, 1,
        "cyan", 0, 65535, 65535, 0, 65535, 65535, 1,
        "CadetBlue", 24415, 40606, 41120, 24415, 40606, 41120, 1,
        "white", 65535, 65535, 65535, 65535, 65535, 65535, 1,
        "black", 0, 0, 0, 0, 0, 0, 1,
        "DarkSlateGray", 12079, 20303, 20303, 12079, 20303, 20303, 1
      ]).
      script_frac("0.6").
      fg_bg_colors('black','white').
      dont_reencode("FFDingbests:ZapfDingbats").
      objshadow_info('#c0c0c0',2,2).
      rotate_pivot(0,0,0,0).
      spline_tightness(1).
      page(1,"",1,'').
      box('black','',64,64,128,128,0,1,1,0,0,0,0,0,0,'1',0,[
      ]).

    EOS
    system "#{bin}/tgif", "-print", "-text", "-quiet", "test.obj"
    assert File.exist?("test.txt")
  end
end
