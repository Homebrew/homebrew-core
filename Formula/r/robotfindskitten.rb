class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "https://robotfindskitten.org/"
  url "https://codeberg.org/robotfindskitten/robotfindskitten/releases/download/3.0000000.726/robotfindskitten-3.0000000.726.tar.gz"
  sha256 "290172b0a04c9a80400bc3b668eb844e24b03a377e2a6b349218b56f7106a1b7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i) # Exclude tags that start with `v`
  end

  bottle do
    sha256 arm64_tahoe:   "79b4d620100949927587e4ec4e3b90399210003b38f4282ddf185fe5d30aa0eb"
    sha256 arm64_sequoia: "bcb3b99eb6b681c89972d4d241983e0b6a6ae8501df0e8991d139976ab678e1f"
    sha256 arm64_sonoma:  "c8f844bda83b6c7e6c0758ce4d040e525597f07ebe1a9c34bdf96e91a49a80b1"
    sha256 sonoma:        "ce2c44cf328b5c5255de4ea6d383c89292974a2867e06bcd49981c57d3a255cd"
    sha256 arm64_linux:   "51011e955535d4fad71b6e80b8cc7f91ffc14a987ad8a29f25f2b7a94aef36b9"
    sha256 x86_64_linux:  "077cb457d00d5086ee14731d29fb7ca3c6c8c88259b23e8d2a18306a11be25b9"
  end

  head do
    url "https://codeberg.org/robotfindskitten/robotfindskitten.git", branch: "main"

    # Used for building shipped robotfindskitten.info from robotfindskitten.texi
    depends_on "texinfo" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    assert_equal "robotfindskitten: #{version}",
      shell_output("#{bin}/robotfindskitten -V").chomp
  end
end
