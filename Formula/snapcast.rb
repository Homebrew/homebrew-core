class Snapcast < Formula
  desc "Synchronous multi-room audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/v0.10.0.tar.gz"
  version "0.0.10"
  sha256 "e4a9e12aca8cfeed5e51866a0143e7e8d0a6e1ce0c076e8f78ce23c5c735c8d3"
  revision 1
  head do
    url "https://github.com/badaix/snapcast.git"
  end
  depends_on "flac" => :build
  depends_on "libvorbis" => :build
  def install
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CXX=#{ENV.cxx}
    ]
    if build.head?
      system "git", "submodule", "update", "--depth", "1", "--init", "--recursive"
    else
      system "git", "clone", "--depth", "1", "https://github.com/badaix/popl.git", "externals/popl"
      system "git", "clone", "--depth", "1", "https://github.com/chriskohlhoff/asio.git", "externals/asio"
      system "git", "clone", "--depth", "1", "git://git.xiph.org/flac.git", "externals/flac"
      system "git", "clone", "--depth", "1", "git://git.xiph.org/ogg.git", "externals/ogg"
      system "git", "clone", "--depth", "1", "git://git.xiph.org/tremor.git", "externals/tremor"
    end
    system "make", "all", "TARGET=MACOS", *args
    mkdir_p bin
    bin.install "client/snapclient"
    bin.install "server/snapserver"
    mkdir_p man
    cp_r "client/snapclient.1", man
    cp_r "server/snapserver.1", man
    cp_r "client/debian/snapclient.plist", prefix
    cp_r "server/debian/snapserver.plist", prefix
    man1.install Dir["#{man}/*.1"]
  end

  def caveats; <<-EOS.undent
    If you get a message that says "illegal hardware instruction  snapclient",
    then you have failed to specify a server for it to connect to.
    To modify snapcasts plist files go to
      #{prefix}/snap[client/server].plist
    EOS
  end
  test do
    system "#{bin}/snapclient", "--version"
    system "#{bin}/snapserver", "--version"
  end
end
