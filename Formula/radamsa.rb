class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://github.com/aoh/radamsa"
  url "https://github.com/aoh/radamsa/releases/download/v0.5/radamsa-0.5.tar.gz"
  sha256 "e21a86aa6dca7e4619085fc60fb664d0a1bd067ca6ebfbcb16ab2d57c8854cb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a971e3bf09f3854d724549a31b98854458b8c49cdfd88593fb14c380066d7bc1" => :high_sierra
    sha256 "d13369632654e12471ff029aa6c08f57e9572df60b9d5b18040ce341ca8b4b09" => :sierra
    sha256 "3b09d787e73444964136ab042bc458610eb4cf08f4ba015cbe7e1d13ab8509f5" => :el_capitan
  end

  def install
    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats; <<~EOS
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    To be able to recompile the source to C, you will need run:
      $ make get-owl

    Tests can be run with:
      $ make .seal-of-quality

    EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
