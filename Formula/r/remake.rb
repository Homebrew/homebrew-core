class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.net/remake/"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.3%2Bdbg-1.6/remake-4.3%2Bdbg-1.6.tar.gz"
  version "4.3-1.6"
  sha256 "f6a0c6179cd92524ad5dd04787477c0cd45afb5822d977be93d083b810647b87"
  license "GPL-3.0-only"

  # We check the "remake" directory page because the bashdb project contains
  # various software and remake releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/remake/"
    regex(%r{href=.*?remake/v?(\d+(?:\.\d+)+(?:(?:%2Bdbg)?[._-]\d+(?:\.\d+)+)?)/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub(/%2Bdbg/i, "") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "f3e10b032f0c417f08105fa2c15a5717151f8da9f094e5244cee0572b38d7d37"
    sha256 arm64_sequoia:  "e653146f267c162714ce0110f5cc892c9a2cbf2e0555922a31f26e65139385ab"
    sha256 arm64_sonoma:   "a4f68de1ce00c29c883c1c43b36b256ae2d5d7575673036467cdac1dd565a84b"
    sha256 arm64_ventura:  "5a7316d4730a456b7a84576294cf3ecc43bb0d66198a56c006b8b6fcd7ee34a8"
    sha256 arm64_monterey: "fe58f73701268996a6f273fd59cc85694152ed4a2e1f2268b22c532c5797a91d"
    sha256 arm64_big_sur:  "95b6ece00e5597ef7277055fbd63584d87255bc1f23168b496cc81bbed99c7ef"
    sha256 sonoma:         "b5cf395e923ae2dd635151eb563064ba9cdfc0521a0109d2a73bec3555289192"
    sha256 ventura:        "cb1b7c4b4f65b0ee7bdc44243f69d45ef825c876f3349d8ed33c892998a2540f"
    sha256 monterey:       "692455854a3099491ec14ab4f1c45cbf9c92002a1ecc4c472e0418b73604901c"
    sha256 big_sur:        "523411a133faf8c381ca3d6ab6b057d42b4a14eaf21b249dc5a0213f5cfe974e"
    sha256 arm64_linux:    "492ff0695438a46997ed2012687feacdb6f30a1a93e47c9be3cad34b76ac8ea1"
    sha256 x86_64_linux:   "caad81ec9c391c8a52c027ee7a7580d324c5743ad8fa1223c9ad11e41772d5b0"
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    # Remove texinfo files for make to avoid conflict
    rm info.glob("make.info*")
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all:
      	echo "Nothing here, move along"
    MAKE
    system bin/"remake", "-x"
  end
end
