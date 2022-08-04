class Veloren < Formula
  desc "Multiplayer voxel RPG"
  homepage "https://veloren.net"
  url "https://gitlab.com/veloren/veloren.git",
      tag:      "v0.13.0",
      revision: "34ae5b9df73f367fa34350337ebba71711f48b86"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rustup-init" => :build

  on_macos do
    # build failure on 10.15 due to coreaudio-sys crate
    depends_on macos: :big_sur
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "python@3.10" => :build
    depends_on "alsa-lib"
    depends_on "libxcb"
    depends_on "libxkbcommon"
    depends_on "systemd" # for libudev
  end

  resource "assets" do
    url "https://gitlab.com/veloren/veloren/-/archive/v0.13.0/veloren-v0.13.0.tar.gz?path=assets"
    sha256 "df22fd58b2e846eb64eb12e2b75c377bdec5caa61fc1cff0bc54dd9765cafde9"
  end

  def install
    resource("assets").stage { libexec.install "assets" }

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    ENV["VELOREN_USERDATA_STRATEGY"] = "system"

    system "cargo", "install", *std_cargo_args(root: libexec, path: "voxygen")
    system "cargo", "install", *std_cargo_args(root: libexec, path: "server-cli")

    (bin/"veloren-voxygen").write_env_script libexec/"bin/veloren-voxygen",
                                             VELOREN_ASSETS: libexec/"assets"
    (bin/"veloren-server-cli").write_env_script libexec/"bin/veloren-server-cli",
                                                VELOREN_ASSETS: libexec/"assets"
  end

  test do
    output = pipe_output(bin/"veloren-server-cli", "shutdown graceful 0")
    assert_match "Server is ready to accept connections", output
  end
end
