class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.43-4549.tar.gz"
  sha256 "a3399661d21e0d965dfef3750d4af7da61eb2924e7b48ee3edaae194ffa5203c"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9689e7dc782eb2d4ba6a37c4892785031972c51a06f299221ad7a354b1273c77"
    sha256 cellar: :any,                 arm64_sequoia: "5a5302c71734043a23f3b908f36c39ce83bfd8c5606775af2ea90e5ec7c2e73a"
    sha256 cellar: :any,                 arm64_sonoma:  "ddc3a7443f8580ab045ac0a938b236bbe5dc76cf818a19c0491c2e0d7f2e0f22"
    sha256 cellar: :any,                 sonoma:        "d91a66cdad84c2a14af8e36c40d63544e965fb37869684b8c9745cf00589b732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af4c880922c1767a187fda85b0f620aa98fb64d7652183df5ad52ab93cc7fe3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c3336e614147bf079ce1c5feb71c03a3757488d0b43dd3e675f9f23ee972a5"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build # needs make 4+
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  # Add sys/time.h header
  # PR ref: https://github.com/tsduck/tsduck/pull/1689
  patch do
    url "https://github.com/tsduck/tsduck/commit/c46fd301f31be8c9aa00ce6d6e21c4e4c6bfc1cf.patch?full_index=1"
    sha256 "c20a1989f2fb528c5326e088beac78cae438c9ea00a93c4b6d04400df7b4ff77"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    else
      ENV["LDFLAGS_EXTRA"] = "-Wl,-rpath,#{rpath(source: lib/"tsduck")}"
    end
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end
