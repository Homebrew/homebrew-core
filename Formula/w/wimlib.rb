class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.3.tar.gz"
  sha256 "1128c6c7916d2f22da80341f84d87d77c620de6500fbb23a741fa79bd08cd1ef"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5984adc28077cc93b22414f1ca76b93869a57b69919c37af25d300b6279f1b4"
    sha256 cellar: :any,                 arm64_ventura:  "b87e344985107b0ae1ac3955e4e70c17f9a88239ceb097f11a7813896e10b76d"
    sha256 cellar: :any,                 arm64_monterey: "2cd14e22f6dba153fde1fa8801527e25718e242cf22f9d85805ba4f20e1874e2"
    sha256 cellar: :any,                 arm64_big_sur:  "765c802a6cca1c15272759ffa3ecc1c72603c2e22c2fd5aa6bf8bd0852ede6e2"
    sha256 cellar: :any,                 sonoma:         "2e082bd22d649b16ed2d73b3e6724d86cc2360391e6421d4eb7bdcf1f24b7c3e"
    sha256 cellar: :any,                 ventura:        "7294142cc77f27cf8e85bdd6b14224bb51d25614dc998308b75ddea51a26439d"
    sha256 cellar: :any,                 monterey:       "8f20ed1089f5e899933a0f658dbb3c1d3b504d6d78a78d9afa7b971b9aafa776"
    sha256 cellar: :any,                 big_sur:        "421aa263f99e18307286e6a48fe36b4e21318f2b9065042c0e2e021d7ab00d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfde6bc50cf2fb295eca9bdadfd81359a8606926f51b2441ef73c8bbfca0404"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    # fuse requires librt, unavailable on OSX
    args = %w[
      --disable-silent-rules
      --without-fuse
      --without-ntfs-3g
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    # make a directory containing a dummy 1M file
    mkdir("foo")
    size = if OS.mac?
      "1m"
    else
      "1M"
    end
    system "dd", "if=/dev/random", "of=foo/bar", "bs=#{size}", "count=1"
    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
