class SpeechTools < Formula
  desc "C++ speech software library from the University of Edinburgh"
  homepage "http://festvox.org/docs/speech_tools-2.4.0/"
  url "http://festvox.org/packed/festival/2.5/speech_tools-2.5.0-release.tar.gz"
  sha256 "e4fd97ed78f14464358d09f36dfe91bc1721b7c0fa6503e04364fb5847805dcc"
  revision 1
  head "https://github.com/festvox/speech_tools.git", branch: "master"

  livecheck do
    url "http://festvox.org/packed/festival/?C=M&O=D"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "134051b43ceb9d7b0c72cd1ae9c6c2381cd0dd74b8360e45a99879519da2bb63"
    sha256 cellar: :any,                 big_sur:      "cabb028b487d5baa5c9c1bb67a982a285ab2af2194ac429fb80f0675e2bd9f6e"
    sha256 cellar: :any,                 catalina:     "e25823939149f50f343c2e6bd8521b302067a0eb3106df6b40ff96b2d1a70c21"
    sha256 cellar: :any,                 mojave:       "3ede4e21772a17e0c0a109151406ad82943ba77b0cad2249c0cac51e063d24ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "367d922ef74f4977cd3fca29461b4814af733073cbba6cc066d5b85a729daf26"
  end

  depends_on "libomp"

  uses_from_macos "ncurses"

  conflicts_with "align", because: "both install `align` binaries"

  def install
    ENV.deparallelize
    # Xcode doesn't include OpenMP directly any more, but with these
    # flags we can force the compiler to use the libomp we provided
    # as a dependency.  Normally you can force this on autoconf by
    # setting "ac_cv_prog_cxx_openmp" and "LIBS", but this configure
    # script does OpenMP its own way so we need to actually edit the script:
    inreplace "configure", "-fopenmp", "-Xpreprocessor -fopenmp -lomp"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # install all executable files in "main" directory
    bin.install Dir["main/*"].select { |f| File.file?(f) && File.executable?(f) }
  end

  test do
    rate_hz = 16000
    frequency_hz = 100
    duration_secs = 5
    basename = "sine"
    txtfile = "#{basename}.txt"
    wavfile = "#{basename}.wav"
    ptcfile = "#{basename}.ptc"

    File.open(txtfile, "w") do |f|
      scale = (2 ** 15) - 1
      samples = Array.new(duration_secs * rate_hz) do |i|
        (scale * Math.sin(frequency_hz * 2 * Math::PI * i / rate_hz)).to_i
      end
      f.puts samples
    end

    # convert to wav format using ch_wave
    system bin/"ch_wave", txtfile,
      "-itype", "raw",
      "-istype", "ascii",
      "-f", rate_hz.to_s,
      "-o", wavfile,
      "-otype", "riff"

    # pitch tracking to est format using pda
    system bin/"pda", wavfile,
      "-shift", (1 / frequency_hz.to_f).to_s,
      "-o", ptcfile,
      "-otype", "est"

    # extract one frame from the middle using ch_track, capturing stdout
    value = frequency_hz * duration_secs / 2
    pitch = shell_output("#{bin}/ch_track #{ptcfile} -from #{value} -to #{value}")

    # should be 100 (Hz)
    assert_equal frequency_hz, pitch.to_i
  end
end
