class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "https://darkside.com.au/snow/"
  url "https://darkside.com.au/snow/snow-20130616.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/snow-20130616.tar.gz"
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?snow[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "53d8451eea7082ead9453a403e836a5287637df3195e25391373df828dda5673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2a2fc6f30db002d270ad215e53e38a9178038ea9b05a19121dbc4ddd8975282f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc3cd801f7bd8ab8d936d3ce543de987c9d4536bebfb2c8d67900c6cb866eb47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b680baf95d8ce110d6afae56c1c693da05a42aa63fd37231a2219ba8b46dc842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58be06402675c829fee62b121da1963c980729658fe428deae9cdb2c8b77b6d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccadf2612c1c8b435711525c30c9d38442f88b4311fa37208d418ff7b10d2fc5"
    sha256 cellar: :any_skip_relocation, ventura:        "281a2edf75fccb88629a899903bfed0a22262d730edbfe96b9a5dc43a6c7acf5"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7e0358dfeecbd209924fc07a7e28493282771f7a6f93b994942d5c911465dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "633bc51f68c437938555787c7c8303298a1faa6811c166bfeda7c7046ccfb614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a378fd9d38675c5924d6fa4a91283e8bb0fcc4e92695c3b222dd55d186ba8ba9"
  end

  conflicts_with "snowflake-cli", because: "both install `snow` binaries"

  def install
    # main.c:180:10: error: call to undeclared library function 'strcmp' with type 'int (const char *, const char *)'
    # main.c:180:10: note: include the header <string.h> or explicitly provide a declaration for 'strcmp'
    inreplace "main.c",
              "#include \"snow.h\"\n",
              "#include \"snow.h\"\n#include <string.h>\n"

    system "make"
    bin.install "snow"
    man1.install "snow.1"
  end

  test do
    touch "in.txt"
    touch "out.txt"
    system bin/"snow", "-C", "-m", "'Secrets Abound Here'", "-p",
           "'hello world'", "in.txt", "out.txt"
    # The below should get the response 'Secrets Abound Here' when testing.
    system bin/"snow", "-C", "-p", "'hello world'", "out.txt"
  end
end
