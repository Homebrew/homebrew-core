class Survex < Formula
  desc "Cave Surveying Tool"
  homepage "https://www.survex.com"
  url "https://survex.com/software/1.2.32/survex-1.2.32.tar.gz"
  sha256 "ac15252618f6a59617ec1142609f04bba69b1f18b3490729e405ff89a4b22852"

  depends_on "wxmac"
  depends_on "proj"
  depends_on "ffmpeg"

  depends_on "gettext" => :build

  def install
    # Allow for non-static linking against PROJ EPSG/ESRI definitions
    ["src/cavern.c", "src/aven.cc"].each { |f| inreplace f, /pj_set_finder\(msg_proj_finder\)/, "" }

    # Prevent assumption that this is a MacOS bundle build
    inreplace "src/message.c", /#ifdef MACOSX_BUNDLE/, "#if 0"

    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--mandir=#{man}",
                          "--docdir=#{doc}",
                          "--datadir=#{share}"

    system "make"
    system "make", "install"

    # Create and populate Aven.app
    mkdir_p ["Aven.app/Contents/MacOS", "Aven.app/Contents/Resources"]
    File.open("Aven.app/Contents/PkgInfo", "w") { |file| file.write("APPLAVEN") }
    cp "lib/Info.plist", "Aven.app/Contents"
    # Aven has some hard-coded assumptions about relative binary locations
    # Workaround until fixed upstream by symlinking these
    ln_s ["#{bin}/aven", "#{bin}/cavern", "#{bin}/extend"], "Aven.app/Contents/MacOS"

    mv "#{pkgshare}/images", "Aven.app/Contents/Resources"
    mv "#{pkgshare}/unifont.pixelfont", "Aven.app/Contents/Resources/"

    # Create MacOS resource icons
    Dir["lib/icons/*.iconset.zip"].each do |isz|
      system "unzip", "-d", "Aven.app/Contents/Resources", isz
      isf = "Aven.app/Contents/Resources/"+isz[/([0-9a-zA-Z]*).iconset(?=.zip)/, 0]
      system "iconutil", "--convert", "icns", isf
      rm_rf isf
    end

    # Remove unnecessary shared resources
    rm_rf ["#{share}/applications", "#{share}/icons", "#{share}/mime-info"]
    prefix.install "Aven.app"
  end

  test do
    (testpath/"test.svx").write <<~EOS
      *begin test
      *cs custom "+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs"
      *cs out custom "+proj=utm +zone=56 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
      *fix 0 150.020166 -33.815585 812
      0 1 10 - DOWN
      *end test
    EOS
    pos = <<~EOS
      ( Easting, Northing, Altitude )
      (224177.87, 6254297.49,   812.00 ) test.0
      (224177.87, 6254297.49,   802.00 ) test.1
    EOS

    system "#{bin}/cavern", (testpath/"test.svx")
    system "#{bin}/3dtopos", (testpath/"test.3d")
    File.open(testpath/"test.pos", "r") { |f| assert_equal f.read, pos }
  end
end
