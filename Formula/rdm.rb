class Rdm < Formula
  desc "Cross-platform GUI management tool for Redis"
  homepage "https://redisdesktop.com/"
  url "https://github.com/uglide/RedisDesktopManager/archive/0.9.9.tar.gz"
  sha256 "8f7244813d5a82bc686a3af9f98e1372479c9861d724ba7e7a2b162ccf35d9bb"
  head "https://github.com/uglide/RedisDesktopManager.git"

  depends_on "cmake" => :build
  depends_on :xcode => :build
  depends_on :macos => :high_sierra
  depends_on "openssl"
  depends_on "qt"

  resource "asyncfuture" do
    url "https://github.com/benlau/asyncfuture/archive/4579d5386e5a95c0adeb88f7aaf9923468bd3d6b.tar.gz"
    sha256 "7038eb9dfc7c17acea9cf6821cc17da43640e67afc1d4bb9515b96a39234d9c9"
  end

  resource "crashreporter" do
    url "https://github.com/RedisDesktop/CrashReporter/archive/0202f9b5bc40b071e4bbcb8724cd30a2c2d219cf.tar.gz"
    sha256 "35a4ad968ca1f30db62fc98dbb8434e86ddad04fb4f6d238abde04d6a92335c5"
  end

  resource "gbreakpad" do
    url "https://github.com/google/breakpad/archive/9fecc95c72549452959431ddc0e4ec4e0cda8689.tar.gz"
    sha256 "380137834d4c1d0e5f8ece4f1a7a27bfe250a123c607e2a8572be41bbb839335"
    patch do
      url "https://chromium-review.googlesource.com/changes/breakpad%2Fbreakpad~1338279/revisions/2/patch?zip"
      sha256 "21b71807c4093b921744340e4b79d8bbb46504cd6ead416dc5a242c4191b71c1"
    end
  end

  resource "hiredis" do
    url "https://github.com/redis/hiredis/archive/685030652cd98c5414ce554ff5b356dfe8437870.tar.gz"
    sha256 "e3dd3d13ae5156d1ab3004b082658d3ad8306881b7d940801bc3102b28d4915d"
  end

  resource "qredisclient" do
    url "https://github.com/uglide/qredisclient/archive/42904d8fe83805c7c850ffaad25939106592efbd.tar.gz"
    sha256 "3e1a9a1235141d911e8e02ed1e0be177c600ed7be230ecac3a57e264a2af64e4"
  end

  def install
    nested_resources = {}
    resources.each do |resource|
      if resource.name == "hiredis"
        nested_resources["qredisclient"] = resource
      else
        resource.stage buildpath/"3rdparty"/resource.name
      end
    end
    nested_resources.each do |parent, resource|
      resource.stage buildpath/"3rdparty"/parent/"3rdparty"/resource.name
    end
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    cd "3rdparty" do
      chmod 0755, "gbreakpad"
      cd "gbreakpad" do
        args = %W[
          -project src/client/mac/Breakpad.xcodeproj
          -configuration Release
          -target Breakpad
          -xcconfig ../../src/gbreakpad.xcconfig
          ARCHS=x86_64
          MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
        ]
        xcodebuild "-sdk", MacOS.sdk_path, "SYMROOT=build", "DSTROOT=#{prefix}", "install", *args
      end
    end
    cd "3rdparty/crashreporter" do
      app_name = "RedisDesktopManager"
      crash_server_url = "http://oops.redisdesktop.com/crash-report"
      app_version = "0.9.9"
      system "#{Formula["qt"].opt_bin}/qmake",
        "CONFIG+=release",
        "DESTDIR=#{buildpath}/bin/osx/release",
        "DEFINES+=APP_NAME=\\\\\\\"" + app_name + "\\\\\\\"",
        "DEFINES+=CRASH_SERVER_URL=\\\\\\\"" + crash_server_url + "\\\\\\\"",
        "DEFINES+=APP_VERSION=\\\\\\\"" + app_version + "\\\\\\\"",
        "crashreporter.pro"
      system "make"
      system "make", "install"
    end
    cd "src" do
      cp "resources/Info.plist.sample", "resources/Info.plist"
      system "#{Formula["qt"].opt_bin}/qmake", "CONFIG-=debug", "CONFIG+=release", "rdm.pro"
      system "make"
      system "make", "install"
    end
    prefix.install "bin/osx/release/rdm.app"
    bin.install_symlink prefix/"rdm.app/Contents/MacOS/rdm"
  end

  test do
    system "#{bin}/rdm", "--version"
  end
end
