class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.0.0.tar.gz"
  sha256 "c00389837ffd02b1bb672624fec7b75434e2d72d55574afd7183758b419ed6a3"
  head "https://github.com/deweller/switchaudio-osx.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "217691f02cb407c7a8e58369579b3233516085f5c54473c2760684f91fff6d37" => :sierra
    sha256 "85af890b6c7965861b474504576fb20c5a7cf4109d88034175c324c956256075" => :el_capitan
    sha256 "8f8a92c4ddbb3cacc4f57c0251900e9221162cfeea63d83d2db7bfcc019d87ee" => :yosemite
    sha256 "01ca5833d2b9c29e1299517feb31ff3bebc72c6a2c409830a0007e6aadc292b3" => :mavericks
  end

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir["build/Release/*"]
    bin.write_exec_script "#{prefix}/SwitchAudioSource"
    chmod 0755, "#{bin}/SwitchAudioSource"
  end

  test do
    system "#{bin}/SwitchAudioSource", "-c"
  end
end
