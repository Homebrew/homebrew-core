class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/R1.tar.gz"
  sha256 "a551354c78fdbe9bcaf29f9a29ee9a7d257ed74d1b6a8403049fcd57855fa0f4"
  license "MIT"
  revision 1
  version_scheme 1

  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "55ae2c3a8f8bf67d64d2346254daf47e219cfbc6d9614b116501f5d55133ef33"
    sha256 cellar: :any, arm64_big_sur:  "03340882c45e954d15c563d411e2ceb2404bc0ea7fed0eb05104a9ce6630236b"
    sha256 cellar: :any, monterey:       "e40bc92d88cc7ff8aa3954bf35d53c79a4ec30d1c4ee0ab2daecebde31a83c2e"
    sha256 cellar: :any, big_sur:        "8e66e52b80e58b395be03091c5db3fa3425a04ef75be84ec7ef9cd076424fd95"
    sha256 cellar: :any, catalina:       "aba262d2cf52d59e3e434ccba8172bd356a27f593057fabc5d2bd576ff7552e1"
    sha256               x86_64_linux:   "def0dfdcb4b66e5dca864366768dc2992acf72bad181de0a7feaee789ba0544d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tesseract"
  depends_on "vapoursynth"

  # Upstream has added a build system, but it's not present in the current release.
  # Remove patch on next update.
  patch do
    url "https://github.com/vapoursynth/vs-ocr/commit/d1e80c6a9d6efe7921300c01ffc0f311927ba443.patch?full_index=1"
    sha256 "6d4ec06e2d3dd5a2b071035775e76475e108cd191f9302ee89b3973420d69925"
  end

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
      "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
      "install_dir : '#{lib}/vapoursynth'"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.ocr"
  end
end
