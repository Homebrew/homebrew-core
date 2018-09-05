class Rock < Formula
  desc "ooc compiler written in ooc"
  homepage "https://ooc-lang.org/"
  url "https://github.com/fasterthanlime/rock/archive/v0.9.10.tar.gz"
  sha256 "39ac190ee457b2ea3c650973899bcf8930daab5b9e7e069eb1bc437a08e8b6e8"
  head "https://github.com/fasterthanlime/rock.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53ea63ea421bebea8bcfab3f6e5bb1cd0c4c79894cd1db629461223acde04295" => :mojave
    sha256 "42f5ed1a2c791553d47aac9af5d3cd594ece8af736d82213b71c663cfc3fe0e1" => :high_sierra
    sha256 "41ded9856a5ee5c923dc04e0d68b49bae33fb779457b1039882065ae312ef120" => :sierra
    sha256 "69c9bbe1cd72a1b0249d0d1504923bbba852d5aa51a7d9742228c9fe793bd0ec" => :el_capitan
    sha256 "3f95d26a49ed30031fd77e9d0e439a6366947201dfc6fd1393ebe5e2924d13d8" => :yosemite
    sha256 "3236af05000a82c81e428244840ca8c2047ca9608b9855998aeb15a78fe1d9e5" => :mavericks
    sha256 "34308d7af495565e3b9bc274615e0e5412a3721fc538ce73f68d973b1cb23a6a" => :mountain_lion
  end

  depends_on "bdw-gc"

  def install
    # make rock using provided bootstrap
    ENV["OOC_LIBS"] = prefix
    system "make", "rescue"
    bin.install "bin/rock"
    man1.install "docs/rock.1"

    # install misc authorship files & rock binary in place
    # copy the sdk, libs and docs
    prefix.install "rock.use", "sdk.use", "sdk-net.use", "sdk-dynlib.use", "pcre.use", "sdk", "README.md"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.ooc").write <<~EOS
      import os/Time
      Time dateTime() println()
    EOS
    system "#{bin}/rock", "--run", "hello.ooc"
  end
end
