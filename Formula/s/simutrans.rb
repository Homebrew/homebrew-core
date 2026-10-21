class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  # Use git checkout to generate revision.h
  url "https://github.com/simutrans/simutrans.git",
      tag:      "125.0.1",
      revision: "40bbb12894793cc7c6ae5c93f31a16e7e7707627"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "01d701f58d3ec3c72a6773c4276f5ec27dbf82f8b2260e3d478b75ae3ff9bee7"
    sha256 cellar: :any, arm64_tahoe:       "561675654ffbc32e23a3077d1db7fc01a93bd4b7a83beb3638e16917a67fa414"
    sha256 cellar: :any, arm64_sequoia:     "1bfca9fd70b6e7eb7b6d45b0dae06102938feefa62a19d6303b27b94ab1d1454"
    sha256 cellar: :any, arm64_linux:       "dafdad86c6d683a20b4d2a63ff0f3fa09241b9b50be27780f8ca6076ba22046d"
    sha256 cellar: :any, x86_64_linux:      "6654684b7e160822533957e4ac262dca4ee2ab9580e796996fb6772eb791ed8f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2-compat"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/125-0/simupak64-125-0.zip"
    sha256 "850108b76505ca306822b88c22a1829c7102a6c9d7390c057f533ba70d9ecdad"
  end

  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  deny_network_access!

  def install
    system "cmake", "-B", "build", "-S", ".", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutrans/simutrans.app/Contents/MacOS" : "simutrans"
    libexec.install "build/#{simutrans_path}/simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "build/src/makeobj/makeobj"
    bin.install "build/src/nettool/nettool"

    libexec.install resource("pak64")
    (libexec/"music").install resource("soundfont")
  end

  test do
    system bin/"simutrans", "--help"
    assert_path_exists libexec/"text/en.tab"
  end
end
