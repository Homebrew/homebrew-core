require "language/node"
require "pp"

class SignalDesktop < Formula
  desc "Signal - Private Messenger - Linux Desktop app for mobile accounts"
  homepage "https://signal.org"
  url "https://github.com/signalapp/Signal-Desktop.git",
      tag:      "v5.14.0",
      revision: "1f748a74067396740f308c6ee8720a64bc4f5059"
  license "AGPL-3.0-only"

  depends_on "git-lfs" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build
  depends_on "alsa-lib"
  depends_on "libfuse@2"
  depends_on "libxshmfence"
  depends_on :linux

  # Inspiration and hints used from:
  # https://build.opensuse.org/package/view_file/network:im:signal/signal-desktop/signal-desktop.spec
  def install
    system "git-lfs", "install"

    # node_modules/playwright
    ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"

    inreplace "package.json" do |s|
      s.sub!(/("node":).*/, "\\1 \"#{Formula["node@14"].version}\"")
      # from OpenSUSE/OBS spec: Use newer node-abi which knows the electron abi
      s.sub!(/("resolutions": {).*/, "\\1 \"sharp/prebuild-install/node-abi\": \"^2.21.0\",")
      s.sub!(/"deb"$/, "\"AppImage\"")
      s.sub!("postinstall", "prepare")
      # stop electron-builder from attempting to publish to github when building in test-bot(1/2)
      s.sub!(/("repository": ).*/, "")
    end
    # stop electron-builder from attempting to publish to github when building in test-bot(2/2):
    system "git", "remote", "remove", "origin"

    system "yarn", "--prefer-offline", "install"
    system "yarn", "--offline", "run-s", "--print-label", "prepare", "build"

    libexec.install "release/Signal-#{version}.AppImage"
    (bin/"signal-desktop.AppImage").write <<~EOS
      #!/bin/sh
      LD_LIBRARY_PATH='#{Formula["alsa-lib"].lib}:#{Formula["libfuse@2"].lib}:#{Formula["libxshmfence"].lib}'
      export LD_LIBRARY_PATH
      #{libexec}/Signal-#{version}.AppImage "$@"
    EOS
    chmod 0755, bin/"signal-desktop.AppImage"
  end

  test do
    # Docker containers have no useable /dev/fuse
    output = shell_output("#{bin}/signal-desktop.AppImage --appimage-extract|grep squashfs-root/signal-desktop")
    assert_match "squashfs-root/signal-desktop", output
    # Without s DISPLAY, Signal Desktop shows some startup information before terminating with a runtime exception
    ENV["LD_LIBRARY_PATH"] = Formula["alsa-lib"].lib.to_s << ":" << Formula["libxshmfence"].lib.to_s
    output = shell_output("DISPLAY= ./squashfs-root/AppRun;echo exit=$?")
    assert_match "whispersystems", output
    assert_match "exit=134", output
  end
end
