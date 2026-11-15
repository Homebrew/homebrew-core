class Wireplumber < Formula
  desc "Session / policy manager implementation for PipeWire"
  homepage "https://pipewire.pages.freedesktop.org/wireplumber/"
  url "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.19/wireplumber-0.5.19.tar.bz2"
  sha256 "e743070200e3788b8a46b5cd35438170dea4458302cfa3bb04ab4a9495ad14a4"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "26738a49d253f94518838d6967acf59587f1c40d056141d7f544ad6c525a99e8"
    sha256 x86_64_linux: "6fa9d624027034ac72b4ee8f4408b3bf9e2ecedec440c42aa88e0ac67f8560cf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "dbus" => :test

  depends_on "glib"
  depends_on :linux
  depends_on "lua"
  depends_on "pipewire"
  depends_on "systemd"

  def install
    args = %W[
      -Ddoc=disabled
      -Dsysconfdir=#{etc}
      -Dsystem-lua=true
      -Dtests=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    ENV["XDG_DATA_DIRS"] = testpath # avoid loading system dbus services
    ENV["XDG_RUNTIME_DIR"] = testpath
    ENV["DBUS_SESSION_BUS_ADDRESS"] = address = "unix:path=#{testpath}/bus"
    dbus_pid = spawn(formula_opt_bin("dbus")/"dbus-daemon", "--session", "--nofork", "--address=#{address}")
    sleep 5
    pipewire_pid = spawn(formula_opt_bin("pipewire")/"pipewire")
    sleep 5
    assert_match "PipeWire 'pipewire-0'", shell_output("#{bin}/wpctl status")
  ensure
    [pipewire_pid, dbus_pid].each do |pid|
      next unless pid

      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
