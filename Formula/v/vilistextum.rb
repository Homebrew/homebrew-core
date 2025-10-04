class Vilistextum < Formula
  desc "HTML to text converter"
  homepage "https://bhaak.net/vilistextum/"
  url "https://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha256 "3a16b4d70bfb144e044a8d584f091b0f9204d86a716997540190100c20aaf88d"
  license "GPL-2.0-only"

  livecheck do
    url "https://bhaak.net/vilistextum/download.html"
    regex(/href=.*?vilistextum[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      # Omit version with old scheme that is incorrectly treated as newest
      # NOTE: This `strategy` block can be removed in the future if/when the
      # download page only contains versions with three parts like 2.3.0.
      page.scan(regex).map { |match| ((version = match.first) == "2.22") ? nil : version }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "49595a548ac3b8e7818c1467db59e825ee7d0ca03d38311b3494451bc40687e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "518d8afa3e88d75bb45459300aa06568ebdb4b712495fac4d0edbe3dcfa17fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ca2e91c4c222843276180c7e4368437fad8284a673b5cd3b26aeb3650204b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6b83b2e8ddabeedb5def8c287c556efa9b442929a98d06171265b7f781e8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63b2fe29b72a3f2203aaf741fa4589b345c6ca5fb761a132cf27a6b5bee5068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfd4ab35a880dbac2c93e43eed5e0001093fad04c94c32f955c3f91822d84ccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cbbc0db2ecdc6e6cd4cc5d6c003e757911c724310d249553a0cd848b26317c7"
    sha256 cellar: :any_skip_relocation, ventura:        "768041a4e365f2dde17beb262782927aed7a6b44f5d6d0290e962ce2b96d0925"
    sha256 cellar: :any_skip_relocation, monterey:       "24296c2112ad6437cf40295a62b10898500ed3c13b2af65f514f8138ea874b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1107f3edeb308819c5b074f1ed2072583c3bc5a7800af162ab10ef460548f18"
    sha256 cellar: :any_skip_relocation, catalina:       "cead55f6cb7e4d66d3f6ca2bf013f0cb653144a0fe79620fdd5735a1e57566a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6a04388664012287fb80e99c0fc242735287a279d74ee7a0e29c4414567c41a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6ebe879dd14d1bf3482d057ab7364ff9851f2ab3d4af5d0a97a59c9c2ca8d8"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `<symbol>`; <file>.o:<location>: first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vilistextum", "-v"
  end
end
