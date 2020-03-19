class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.6.1.tar.gz"
  sha256 "e77ba3c80cdd93ca02c34098b9b7f918df3d648c87f1ed5d94fe854debd6d101"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cbeef8a18f26bf9c0d988e40f1aea3fae9695e99644cd7253dd13ef340c37a5" => :catalina
    sha256 "44cd735483145a0f969ab412cd0540ed7936512afb1c902bd9b7258e530d60a4" => :mojave
    sha256 "22823e8c4cf694fabeea049a0a0debf38b3be79de73f6ac62a65a9fe45bec93c" => :high_sierra
    sha256 "fbf3f82768d3ea1a8f6b60dd593e838beb05c3529c3a89b4ecb743a53e26d7b6" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
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

        #include \"stk/FileLoop.h\"
        #include \"stk/FileWvOut.h\"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
