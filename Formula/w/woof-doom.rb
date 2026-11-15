class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://fabiangreffrath.github.io/woof/"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_16.0.0.tar.gz"
  sha256 "293bc5ad61eaac191ee1cb652c797819459a7f7819d4aec78a847c8e13695342"
  license all_of: [
    # Default license is GPL-2.0-or-later but `woof` binary ends up GPL-3.0-or-later
    "GPL-2.0-or-later",
    "GPL-3.0-or-later", # src/v_flextran.*, src/v_video.*

    # Other licenses
    "BSD-2-Clause", # third-party/spng/*
    "BSD-3-Clause", # src/m_scanner.*, base/all-all/sprites/pls*, man/simplecpp
    "CC-BY-3.0",    # base/all-all/sm*.png, data/setup.ico, data/woof*, setup/setup_icon.c, src/icon.c
    "CC0-1.0",      # base/all-all/sbardef.lmp, data/io.github.fabiangreffrath.woof.metainfo.*
    "GPL-2.0-only", # soundfonts/TimGM6mb.sf2
    "MIT",          # src/i_flickstick.*, src/i_gyro.*, src/nano_bsp.*, base/all-all/dmxopl.op2, third-party/miniz/*
    "NCL",          # third-party/pffft/*
    :public_domain, # third-party/md5/*
    "CC-BY-SA-4.0", # textscreen/fonts/hauge-8x18-v1-6.png
    "Zlib",         # netlib
  ]
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8969e252e1c0d09162c4b251de699b592cfbf3849880e3b7da3717d49dc0102"
    sha256 cellar: :any, arm64_tahoe:       "3dbe3946b6b53823bed162bd0f7bba3f67bbcdd6f72b5ca1d3647f260e236ca7"
    sha256 cellar: :any, arm64_sequoia:     "24a707a898c4a12bf36e07cc647c7dfde7b079c464c72f9195cdeabd6dec03b6"
    sha256 cellar: :any, arm64_sonoma:      "d0b1d36695982146b48f1463b73de437486b16dd9a149c30e09e1c94b8d1df95"
    sha256 cellar: :any, arm64_linux:       "f5bd090faba4bceb743971b7e807149b9cd9a3e2cf4f7578d61ffcf4adc59656"
    sha256 cellar: :any, x86_64_linux:      "0aa309e0053ff89354b86e299fccb2a215c054da5acd6a70e5aca3c30acebac3"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl3"
  depends_on "yyjson"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

  def install
    # Remove bundled libraries
    rm_r("third-party/yyjson")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test_invalid.wad").write <<~EOS
      Invalid IWAD file
    EOS

    expected_output = "Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}/woof -version")
  end
end
