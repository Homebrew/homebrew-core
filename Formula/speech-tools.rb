class SpeechTools < Formula
  desc "C++ speech software library from the University of Edinburgh"
  homepage "http://festvox.org/docs/speech_tools-2.4.0/"
  url "http://festvox.org/packed/festival/2.5/speech_tools-2.5.0-release.tar.gz"
  sha256 "e4fd97ed78f14464358d09f36dfe91bc1721b7c0fa6503e04364fb5847805dcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9df2392e021ab65fdcdc691fe3b2fbfc8037472a4bd40b0678cba885984c6c8c" => :high_sierra
    sha256 "fdd91c9e012e6e6849c202dbeaa5fcec9ae740e915f350e5881f3ee0aafcea60" => :sierra
    sha256 "f61c67afcd6c5f54b402183cb5148cf51cad67c95ce01bb3db0df57d384cc7e3" => :el_capitan
    sha256 "48091e873f0d038ebc6e46ab3ca7c1e494d061afab3dae64e1dbd594e4afccbe" => :yosemite
    sha256 "dca2c0deebfd3bd6aeba1cfaa4f72a3cc29b90e879fd51ed38c2524d1789eaad" => :mavericks
    sha256 "16895a28e900f2b7d209d2c4dda0228024c6da9627189f356c631f1b8c990c27" => :mountain_lion
  end

  conflicts_with "align", :because => "both install `align` binaries"

  def install
    ENV.deparallelize
    system "./configure"
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
      scale = 2 ** 15 - 1
      f.puts Array.new(duration_secs * rate_hz) { |i| (scale * Math.sin(frequency_hz * 2 * Math::PI * i / rate_hz)).to_i }
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
    pitch = shell_output("#{bin}/ch_track #{ptcfile} -from #{frequency_hz * duration_secs / 2} -to #{frequency_hz * duration_secs / 2}")

    # should be 100 (Hz)
    assert_equal frequency_hz, pitch.to_i
  end
end
