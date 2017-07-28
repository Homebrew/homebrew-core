class Utid < Formula
  desc "Select default apps for documents and URL schemes on macOS. From 'duti'."
  homepage "https://github.com/jorvi/utid"
  url "https://github.com/jorvi/utid/archive/1.8.1.tar.gz"
  sha256 "b0d4a38a699e06ed43bbf485f661a0beb7ed0913ecece14a460d2007e88ae49d"
  head "https://github.com/jorvi/utid.git"

  def install
    bin.mkpath
    system "make"
    bin.install "utid"
    man1.install "utid.1"
  end

  test do
    system "#{bin}/utid", "-x", "txt"
  end

end
