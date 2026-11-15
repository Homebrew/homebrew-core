class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-5.0.1.tar.gz"
  sha256 "afc35faea3bb8baacacb8d9db3fa745e4f7d8dd46f36aac5436ca377d565a184"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://ccrma.stanford.edu/software/stk/download.html"
    regex(/href=.*?stk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "824f5a67e81886214168ec94e8d38f93bb169013e182aff5d1c3aa1b832f63a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14b11f68c2557197e095d18b4ef4165afee87aec1d094e11665ee4f3ba457fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8050290142b2bd021e4ab23875affcc51996f459f8dbad28b6428df44383afdb"
    sha256 cellar: :any,                 arm64_linux:       "2b816f2bfaee8682d4717e0ad0118efa11a04e92b9aff21b9f089f9ea9cc8138"
    sha256 cellar: :any,                 x86_64_linux:      "ac6eb9225f58b77cd508c338154016eac3d9d83f9eb7b511aa9adaf34b196d4a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-dependency-tracking"] }
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats
    <<~EOS
      The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

        #include "stk/FileLoop.h"
        #include "stk/FileWvOut.h"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
